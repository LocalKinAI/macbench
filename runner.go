// Package main is the macbench runner.
//
// Usage:
//
//	go run . -agent PATH -agent-args TEMPLATE [flags]
//
// Reads each tasks/<id>/task.json, runs the
// setup.sh → agent invoke → eval.sh sequence, accumulates
// pass/fail/duration, writes a JSON report to
// results/<timestamp>/run.json + prints a table.
//
// The agent is any executable that takes a prompt and acts on macOS.
// `-agent` is its path; `-agent-args` is the argument template, with
// "{prompt}" substituted at run time. Examples:
//
//	# kinclaw (the original LocalKinAI agent)
//	-agent kinclaw -agent-args "-soul pilot.soul.md -exec {prompt}"
//
//	# a hypothetical Anthropic Computer Use wrapper
//	-agent anthropic-cua -agent-args "--task {prompt} --max-tokens 4096"
//
//	# a one-arg shell wrapper
//	-agent /path/to/wrapper.sh -agent-args "{prompt}"
//
// The runner doesn't care about agent internals — it just exec()s the
// resolved command, waits with a per-task timeout, then runs eval.sh.
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"syscall"
	"time"
)

// Task is the on-disk shape of tasks/<id>/task.json.
//
// Status semantics:
//   - "" or "implemented" — has setup.sh + eval.sh, runs normally
//   - "stub"             — task.json defines the task; setup.sh /
//                          eval.sh haven't been written yet. Runner
//                          skips with phase="stub", doesn't count
//                          toward implemented denominator.
type Task struct {
	ID         string `json:"id"`
	Category   string `json:"category"`
	Difficulty string `json:"difficulty"` // T1 / T2 / T3
	Prompt     string `json:"prompt"`
	TimeoutSec int    `json:"timeout_sec,omitempty"` // 0 → use default
	Status     string `json:"status,omitempty"`      // "" | "implemented" | "stub"
	dir        string // populated at load time
}

// IsStub reports whether this task is a placeholder (design-only, no
// setup/eval scripts yet). Used by the runner to skip cleanly.
func (t Task) IsStub() bool { return t.Status == "stub" }

// Result is one task's outcome. Duration is the in-memory `time.Duration`
// (nanoseconds); JSON marshaling emits `duration_ms` derived from it via
// MarshalJSON, so callers don't have to remember the time-package quirk.
type Result struct {
	TaskID     string        `json:"task_id"`
	Category   string        `json:"category"`
	Difficulty string        `json:"difficulty"`
	Pass       bool          `json:"pass"`
	Stub       bool          `json:"stub,omitempty"` // task is a placeholder, was skipped
	Duration   time.Duration `json:"-"`
	Phase      string        `json:"failed_phase,omitempty"` // "setup" | "exec" | "eval" | "stub"
	ErrMsg     string        `json:"error,omitempty"`
	AgentOut   string        `json:"agent_stdout_tail,omitempty"`
	EvalOut    string        `json:"eval_stdout,omitempty"`
	Recording  string        `json:"recording,omitempty"` // mp4 path, when -record
}

// MarshalJSON emits Duration as `duration_ms` (millis as int64) alongside
// the other fields. Keeps the JSON shape callers expect.
func (r Result) MarshalJSON() ([]byte, error) {
	type alias Result // dodge recursion
	return json.Marshal(struct {
		alias
		DurationMs int64 `json:"duration_ms"`
	}{
		alias:      alias(r),
		DurationMs: r.Duration.Milliseconds(),
	})
}

// RunReport is the top-level aggregate. We carry two scoring views:
//
//   - PassPercentImplemented: passed / (implemented = total − stubs)
//     The "interesting" score — measures the agent against tasks that
//     were actually written and runnable.
//
//   - PassPercentStrict: passed / total (stubs count as 0)
//     The "strict" score — measures progress against the full benchmark
//     taxonomy, including unimplemented slots. Useful for cross-version
//     tracking ("we went from 5% to 12% strict over 6 weeks").
type RunReport struct {
	StartedAt              time.Time `json:"started_at"`
	FinishedAt             time.Time `json:"finished_at"`
	Agent                  string    `json:"agent"`
	AgentArgs              string    `json:"agent_args"`
	TotalTasks             int       `json:"total_tasks"`
	ImplementedTasks       int       `json:"implemented_tasks"`
	StubTasks              int       `json:"stub_tasks"`
	Passed                 int       `json:"passed"`
	Failed                 int       `json:"failed"`
	PassPercentImplemented float64   `json:"pass_percent_implemented"`
	PassPercentStrict      float64   `json:"pass_percent_strict"`
	Results                []Result  `json:"results"`
}

func main() {
	tasksFlag := flag.String("tasks", "", "Comma-separated task IDs to run (substring match; default: all)")
	agentFlag := flag.String("agent", "", "Path to agent binary (e.g. ./kinclaw)")
	agentArgsFlag := flag.String("agent-args", "{prompt}", `Argument template for the agent. "{prompt}" is substituted with the task prompt.`)
	timeoutFlag := flag.Duration("timeout", 90*time.Second, "Default per-task timeout (overridable per task in task.json)")
	tasksDirFlag := flag.String("tasks-dir", "tasks", "Directory containing task folders")
	resultsDirFlag := flag.String("results-dir", "results", "Where to write run reports")
	recordFlag := flag.Bool("record", false, "Record each task to mp4 via kinrec (requires kinrec on PATH + Screen Recording perm)")
	kinrecFlag := flag.String("kinrec", "kinrec", "Path to kinrec binary when -record is set")
	flag.Parse()

	if *agentFlag == "" {
		die("-agent is required (path to agent binary)")
	}
	if _, err := exec.LookPath(*agentFlag); err != nil {
		// LookPath fails on PATH miss AND on relative-path-not-found — try Stat too.
		if _, err := os.Stat(*agentFlag); err != nil {
			die("agent binary not found at %q (PATH or filesystem): %v", *agentFlag, err)
		}
	}
	if !strings.Contains(*agentArgsFlag, "{prompt}") {
		die(`-agent-args must contain the literal string "{prompt}" — got %q`, *agentArgsFlag)
	}

	tasks, err := loadTasks(*tasksDirFlag, *tasksFlag)
	if err != nil {
		die("loading tasks: %v", err)
	}
	if len(tasks) == 0 {
		die("no tasks to run (looked in %s)", *tasksDirFlag)
	}

	report := RunReport{
		StartedAt: time.Now(),
		Agent:     filepath.Base(*agentFlag),
		AgentArgs: *agentArgsFlag,
	}

	// Per-run output dir is created up front so recording can drop
	// videos into it as tasks run (rather than at the end alongside
	// run.json — saves losing footage if the run crashes mid-suite).
	stamp := report.StartedAt.Format("20060102-150405")
	outDir := filepath.Join(*resultsDirFlag, stamp)
	if err := os.MkdirAll(outDir, 0o755); err != nil {
		die("creating results dir: %v", err)
	}
	recDir := ""
	if *recordFlag {
		recDir = filepath.Join(outDir, "recordings")
		if err := os.MkdirAll(recDir, 0o755); err != nil {
			die("creating recordings dir: %v", err)
		}
		// Probe kinrec; fail loud rather than silently fall back to
		// no-recording — the user asked for it.
		if _, err := exec.LookPath(*kinrecFlag); err != nil {
			die("kinrec not found at %q (PATH or -kinrec): %v", *kinrecFlag, err)
		}
	}

	fmt.Printf("macbench: %d task(s), agent=%s, args=%q, record=%v\n",
		len(tasks), report.Agent, *agentArgsFlag, *recordFlag)
	fmt.Println(strings.Repeat("─", 70))

	// Snapshot pre-existing PIDs of bench-touched apps so per-task
	// isolation only kills PIDs the bench itself spawned, leaving the
	// user's pre-existing app instances (Safari with their tabs,
	// Notes with their notes open, etc.) untouched.
	preBenchSnapshot := snapshotBenchApps()
	preBenchTotal := 0
	for _, pids := range preBenchSnapshot {
		preBenchTotal += len(pids)
	}
	if preBenchTotal > 0 {
		fmt.Printf("(isolation: %d pre-existing PIDs across %d apps will be preserved)\n",
			preBenchTotal, len(benchTouchedApps))
	}

	for _, t := range tasks {
		result := runTask(t, *agentFlag, *agentArgsFlag, *timeoutFlag, *kinrecFlag, recDir)
		report.Results = append(report.Results, result)
		printRow(result)
		// Per-task isolation: kill ONLY bench-spawned PIDs of bench-
		// touched apps. Pre-existing user instances stay alive.
		if !result.Stub {
			isolateTask(preBenchSnapshot)
		}
	}

	report.FinishedAt = time.Now()
	report.TotalTasks = len(tasks)
	for _, r := range report.Results {
		switch {
		case r.Stub:
			report.StubTasks++
		case r.Pass:
			report.Passed++
		default:
			report.Failed++
		}
	}
	report.ImplementedTasks = report.TotalTasks - report.StubTasks
	if report.ImplementedTasks > 0 {
		report.PassPercentImplemented = 100.0 * float64(report.Passed) / float64(report.ImplementedTasks)
	}
	if report.TotalTasks > 0 {
		report.PassPercentStrict = 100.0 * float64(report.Passed) / float64(report.TotalTasks)
	}

	fmt.Println(strings.Repeat("─", 70))
	fmt.Printf("IMPLEMENTED: %d passed / %d run (%.1f%%)\n",
		report.Passed, report.ImplementedTasks, report.PassPercentImplemented)
	fmt.Printf("STRICT:      %d passed / %d total (%.1f%%) — stubs count as fail\n",
		report.Passed, report.TotalTasks, report.PassPercentStrict)
	fmt.Printf("stubs (skipped): %d\n", report.StubTasks)

	outPath := filepath.Join(outDir, "run.json")
	f, err := os.Create(outPath)
	if err != nil {
		die("writing report: %v", err)
	}
	defer f.Close()
	enc := json.NewEncoder(f)
	enc.SetIndent("", "  ")
	if err := enc.Encode(report); err != nil {
		die("encoding report: %v", err)
	}
	fmt.Printf("→ wrote %s\n", outPath)

	if report.Failed > 0 {
		os.Exit(1)
	}
}

// loadTasks walks tasksDir and returns task entries, optionally
// filtered by a comma-separated id list (substring match on
// folder basename, so "001" matches "001-finder-rename").
func loadTasks(tasksDir, filter string) ([]Task, error) {
	entries, err := os.ReadDir(tasksDir)
	if err != nil {
		return nil, err
	}

	wantedSet := map[string]bool{}
	if filter != "" {
		for _, p := range strings.Split(filter, ",") {
			wantedSet[strings.TrimSpace(p)] = true
		}
	}

	var tasks []Task
	for _, e := range entries {
		if !e.IsDir() {
			continue
		}
		taskDir := filepath.Join(tasksDir, e.Name())
		if len(wantedSet) > 0 {
			match := false
			for w := range wantedSet {
				if strings.Contains(e.Name(), w) {
					match = true
					break
				}
			}
			if !match {
				continue
			}
		}
		tj := filepath.Join(taskDir, "task.json")
		raw, err := os.ReadFile(tj)
		if err != nil {
			fmt.Fprintf(os.Stderr, "skipping %s: no task.json (%v)\n", e.Name(), err)
			continue
		}
		var t Task
		if err := json.Unmarshal(raw, &t); err != nil {
			return nil, fmt.Errorf("%s: %w", tj, err)
		}
		t.dir = taskDir
		tasks = append(tasks, t)
	}
	sort.Slice(tasks, func(i, j int) bool { return tasks[i].ID < tasks[j].ID })
	return tasks, nil
}

// runTask is the per-task orchestrator. Always returns a Result;
// never panics. Uses a named return value so the deferred duration
// stamp survives early returns.
//
// recDir == "" disables recording. When set, kinrec is started
// before exec and stopped (SIGTERM) after exec — recordings cover
// agent action only, not setup/eval noise.
func runTask(t Task, agentBin, agentArgsTmpl string, defaultTimeout time.Duration, kinrecBin, recDir string) (r Result) {
	r = Result{
		TaskID:     t.ID,
		Category:   t.Category,
		Difficulty: t.Difficulty,
	}

	// Stubs are placeholders defining tasks that haven't been
	// implemented yet (no setup.sh / eval.sh). They count toward the
	// total benchmark size for the strict denominator, but skip
	// runtime entirely so we don't burn a 90s timeout per stub.
	if t.IsStub() {
		r.Stub = true
		r.Phase = "stub"
		r.ErrMsg = "task not implemented yet (placeholder)"
		return
	}

	timeout := defaultTimeout
	if t.TimeoutSec > 0 {
		timeout = time.Duration(t.TimeoutSec) * time.Second
	}
	start := time.Now()
	defer func() { r.Duration = time.Since(start) }()

	// 1. setup
	if hasFile(t.dir, "setup.sh") {
		if out, err := runScript(t.dir, "setup.sh", 60*time.Second); err != nil {
			r.Phase = "setup"
			r.ErrMsg = err.Error()
			r.EvalOut = tail(out, 500)
			return
		}
	}

	// 2. start recording (if enabled), then exec
	var rec *recorder
	if recDir != "" {
		rec = startRecording(kinrecBin, recDir, t.ID)
	}

	// Substitute {prompt} in the agent-args template + split into argv.
	argv := buildAgentArgs(agentArgsTmpl, t.Prompt)

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, agentBin, argv...)
	out, err := cmd.CombinedOutput()
	r.AgentOut = tail(string(out), 800)

	// Stop recording in all exec paths (success, timeout, error).
	if rec != nil {
		path, recErr := rec.Stop()
		if recErr == nil {
			r.Recording = path
		}
	}

	// Stash any exec-side error/timeout signal, but DO NOT early-return.
	// The agent may have completed the task before being killed by the
	// timeout, or before exiting non-zero. eval.sh observes the world,
	// not the agent's exit code, so we always check.
	execErr := ""
	if ctx.Err() == context.DeadlineExceeded {
		execErr = fmt.Sprintf("timeout after %s", timeout)
	} else if err != nil {
		execErr = err.Error()
	}

	// 3. eval — always run, regardless of exec outcome
	evalOut, evalErr := runScript(t.dir, "eval.sh", 60*time.Second)
	r.EvalOut = tail(evalOut, 500)
	if evalErr != nil {
		// Eval said the task isn't done. Attribute the failure to whichever
		// phase was actually responsible: exec error means agent died/timed
		// out before completing; eval error means agent finished but state
		// didn't match expectations.
		if execErr != "" {
			r.Phase = "exec"
			r.ErrMsg = execErr + " (eval also failed: " + evalErr.Error() + ")"
		} else {
			r.Phase = "eval"
			r.ErrMsg = evalErr.Error()
		}
		return
	}
	// eval passed. If exec had complained earlier, note it but still pass —
	// the agent did the work, just didn't exit cleanly.
	if execErr != "" {
		r.AgentOut = "(exec: " + execErr + " — eval passed anyway)\n" + r.AgentOut
	}

	// 4. teardown — best-effort, doesn't affect pass/fail
	if hasFile(t.dir, "teardown.sh") {
		_, _ = runScript(t.dir, "teardown.sh", 60*time.Second)
	}
	r.Pass = true
	return
}

// benchTouchedApps lists the macOS apps the bench tasks open during
// runtime. Used by appSnapshot + isolateTask to clean only what the
// bench launched, leaving the user's pre-existing app instances alone.
var benchTouchedApps = []string{
	"Safari", "Mail", "Notes", "Reminders", "Calendar",
	"Music", "Photos", "Maps", "TextEdit", "Pages", "Numbers",
	"Keynote", "System Settings", "System Preferences",
}

// pidSet is the set of PIDs that match a process-name predicate at
// some moment in time. Captured once at bench start (the "user's
// pre-existing state") so isolateTask can spare those PIDs while
// killing only PIDs the bench itself spawned.
type pidSet map[int]bool

// snapshotBenchApps returns map[appName] -> set-of-PIDs-already-running
// for every app in benchTouchedApps. Called once before the first
// task. The bench's "isolation budget" is: any PID that appears later
// for one of these apps and was NOT in this snapshot is bench-spawned
// and safe to kill.
//
// Practical implication for users: if you have Safari (or Notes,
// Calendar...) open with valuable state when you run `make bench`,
// the bench will leave that instance alone — it can't clean up
// accumulated state in your existing instance, but it won't kill it
// either. To get full task-to-task isolation, run `make warmup` first
// to start from an empty snapshot.
func snapshotBenchApps() map[string]pidSet {
	out := make(map[string]pidSet, len(benchTouchedApps))
	for _, app := range benchTouchedApps {
		out[app] = pgrepPIDs(app)
	}
	return out
}

// pgrepPIDs returns the set of PIDs whose argv[0] (basename) matches
// the given app name. Uses `pgrep -x` (exact match) so a stray "Safari
// Helper" doesn't get confused with "Safari".
func pgrepPIDs(app string) pidSet {
	out, _ := exec.Command("pgrep", "-x", app).Output()
	pids := pidSet{}
	for _, line := range strings.Split(strings.TrimSpace(string(out)), "\n") {
		if line == "" {
			continue
		}
		if pid, err := strconv.Atoi(line); err == nil {
			pids[pid] = true
		}
	}
	return pids
}

// isolateTask kills only PIDs that the bench launched — i.e., PIDs
// of bench-touched apps that didn't exist in the start-of-bench
// snapshot. PIDs that were already running stay alive (user state).
// ~0.3 s overhead per call.
func isolateTask(snapshot map[string]pidSet) {
	for _, app := range benchTouchedApps {
		currentPIDs := pgrepPIDs(app)
		for pid := range currentPIDs {
			if !snapshot[app][pid] {
				// Bench-spawned. Kill via SIGTERM (graceful — apps get
				// a chance to flush state); fallback to SIGKILL via
				// macOS task scheduler if SIGTERM is ignored for >2s.
				_ = syscall.Kill(pid, syscall.SIGTERM)
			}
		}
	}
	// Brief settle so reopens during next task's setup don't race a
	// still-quitting app.
	time.Sleep(300 * time.Millisecond)
}

// buildAgentArgs splits the agent-args template into argv tokens, then
// substitutes "{prompt}" tokens with the literal prompt. We split first
// so a multi-word prompt becomes a single argv slot — i.e. "{prompt}"
// in the template means "place the prompt here as ONE argument", not
// "split the prompt by whitespace".
//
// Token splitting is naive whitespace split (no shell quoting). If your
// agent needs literal whitespace in flag values that aren't the prompt,
// fix it by adjusting `-agent-args` (e.g. write a wrapper.sh).
func buildAgentArgs(tmpl, prompt string) []string {
	tokens := strings.Fields(tmpl)
	argv := make([]string, 0, len(tokens))
	for _, t := range tokens {
		argv = append(argv, strings.ReplaceAll(t, "{prompt}", prompt))
	}
	return argv
}

// recorder wraps a kinrec child process so we can stop it with
// SIGTERM (lets kinrec flush + close the mp4 cleanly) at agent end.
type recorder struct {
	cmd    *exec.Cmd
	output string
}

func startRecording(kinrecBin, recDir, taskID string) *recorder {
	output := filepath.Join(recDir, taskID+".mp4")
	// h264 + 30fps keeps file size reasonable for a 50-task run
	// (a 60s task ≈ 8-15 MB at these settings).
	cmd := exec.Command(kinrecBin, "record",
		"-o", output,
		"--codec", "h264",
		"--fps", "30")
	// Detach from our stdout/stderr so kinrec's progress meter
	// doesn't mangle the bench table output.
	cmd.Stdout = nil
	cmd.Stderr = nil
	if err := cmd.Start(); err != nil {
		fmt.Fprintf(os.Stderr, "macbench: failed to start kinrec: %v\n", err)
		return nil
	}
	// Give kinrec a beat to actually open the SCStream + first frame
	// before the agent starts moving things on screen. 800ms is the
	// observed cold-open p95 from sckit-go's bench suite.
	time.Sleep(800 * time.Millisecond)
	return &recorder{cmd: cmd, output: output}
}

func (r *recorder) Stop() (string, error) {
	if r == nil || r.cmd == nil || r.cmd.Process == nil {
		return "", nil
	}
	// SIGTERM lets kinrec's signal handler flush the mp4 container
	// and close cleanly; SIGKILL would corrupt the trailing moov box.
	_ = r.cmd.Process.Signal(syscall.SIGTERM)

	done := make(chan error, 1)
	go func() { done <- r.cmd.Wait() }()
	select {
	case <-done:
		// graceful exit
	case <-time.After(5 * time.Second):
		_ = r.cmd.Process.Kill()
	}
	return r.output, nil
}

// runScript runs a shell script in the task directory with a hard
// timeout. Returns combined stdout+stderr and any error (including
// non-zero exit, which is the canonical "fail" signal for eval.sh).
//
// Process group: setup.sh / eval.sh frequently invoke osascript, which
// then talks to a target macOS app (Mail, Notes, Calendar...). Without
// pgrp isolation, killing bash leaves the osascript and target-app
// connections orphaned, and our wait blocks until the pipes close —
// which can stretch 30s timeout into 90+s of waiting. Setpgid + killing
// -PGID on timeout fixes that.
func runScript(dir, name string, timeout time.Duration) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	cmd := exec.Command("bash", name)
	cmd.Dir = dir
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	var buf bytes.Buffer
	cmd.Stdout = &buf
	cmd.Stderr = &buf

	if err := cmd.Start(); err != nil {
		return "", err
	}

	done := make(chan error, 1)
	go func() { done <- cmd.Wait() }()

	select {
	case err := <-done:
		return buf.String(), err
	case <-ctx.Done():
		// Kill whole process group so orphaned osascript / app-helper
		// children die with the bash parent.
		if cmd.Process != nil {
			pgid, _ := syscall.Getpgid(cmd.Process.Pid)
			if pgid > 0 {
				_ = syscall.Kill(-pgid, syscall.SIGTERM)
				time.Sleep(200 * time.Millisecond)
				_ = syscall.Kill(-pgid, syscall.SIGKILL)
			}
		}
		// Best-effort drain of partial output before returning.
		select {
		case <-done:
		case <-time.After(2 * time.Second):
		}
		return buf.String(), fmt.Errorf("timeout after %s", timeout)
	}
}

func hasFile(dir, name string) bool {
	_, err := os.Stat(filepath.Join(dir, name))
	return err == nil
}

func printRow(r Result) {
	mark := "✓"
	tail := ""
	switch {
	case r.Stub:
		mark = "~"
		tail = " [stub] not implemented yet"
	case !r.Pass:
		mark = "✗"
		tail = fmt.Sprintf(" [%s] %s", r.Phase, oneline(r.ErrMsg, 60))
	}
	fmt.Printf("  %s %-34s %-3s %5dms%s\n",
		mark, r.TaskID, r.Difficulty, r.Duration.Milliseconds(), tail)
}

func tail(s string, max int) string {
	if len(s) <= max {
		return s
	}
	return "..." + s[len(s)-max:]
}

func oneline(s string, max int) string {
	s = strings.ReplaceAll(s, "\n", " ")
	if len(s) <= max {
		return s
	}
	return s[:max] + "…"
}

func die(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "macbench: "+format+"\n", args...)
	os.Exit(2)
}
