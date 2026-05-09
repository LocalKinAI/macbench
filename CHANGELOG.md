# Changelog

All notable changes to macbench are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-05-09

### Added

- **Zenodo concept DOI for v0.1 paper:** [`10.5281/zenodo.20094244`](https://doi.org/10.5281/zenodo.20094244)
  (auto-resolves to the latest version). The paper *macbench: A
  macOS-Native Computer-Use Benchmark for Autonomous Agents* is now
  permanently archived (CC-BY-4.0). The PDF bundles EN + 中文 in a
  single document, generated directly from the canonical Markdown
  source via pandoc → HTML → Chrome. README now carries the Zenodo
  DOI badge. Bilingual mirror at
  [localkin.dev/papers/macbench](https://www.localkin.dev/papers/macbench).

## [0.1.0] - 2026-05-08

Initial public release. The first publicly published macOS-native
computer-use benchmark for autonomous agents (as far as we know).

### Headline numbers

```
First reference run — kinclaw v1.15.0 + Kimi-K2.5(cloud):
  IMPLEMENTED:  101 / 150  =  67.3%
  STRICT:       101 / 369  =  27.4%   (stubs count as fail)
  Run time:     ~95 minutes with per-task PID-snapshot isolation
```

### Added

#### Task corpus

- **369 task slots** across 15 macOS-native categories: Finder,
  Safari, Mail, Notes, Calendar, Reminders, Settings, Terminal,
  Pages, Numbers, Keynote, Music, Photos, Maps, Multi-app.
- **150 tasks fully implemented** with deterministic
  `setup.sh` + `eval.sh` (+ optional `teardown.sh`). Each task is
  natural-language prompt + filesystem/`defaults`/AppleScript/sqlite
  eval — no LLM-as-judge anywhere.
- **219 stubs** with real, specific prompts + correct
  category/difficulty assignments. Stubs short-circuit at runtime
  (0 ms) and count toward the STRICT denominator. Filling them in
  is the v0.2 → v1.0 work.
- **3 difficulty tiers** — T1 (single-app, single-step) /
  T2 (single-app, multi-step) / T3 (cross-app, semantic).

#### Runner (Go, ~520 LOC)

- **Agent-agnostic invocation** — `-agent PATH` + `-agent-args
  TEMPLATE` where `{prompt}` is substituted with the task prompt.
  Anthropic Computer Use, OpenAI CUA, kinclaw, or any custom
  shell wrapper plugs in via flags; no agent-specific code in
  the runner.
- **Dual scoring** — `IMPLEMENTED` (passed / runnable, ignoring
  stubs; the "interesting" score) + `STRICT` (passed / 369,
  stubs count as fail; the "long-game" score). Both in `run.json`.
- **Per-task PID-snapshot isolation** — runner records PIDs of
  bench-touched apps at startup; between every task, kills only
  PIDs the bench itself spawned, preserving any pre-existing user
  instance. Eliminates the "agent does 5 prior tasks in one
  prompt" pollution observed in pre-isolation runs and prevents
  Notes / Calendar / Reminders from accumulating AppleScript hangs
  after ~5-10 invocations.
- **Eval always runs** — even if the agent process exited non-zero
  or hit per-task timeout. Many tasks complete the action then
  keep exploring; eval observes the world, not the agent's exit
  code, so a partial-success run still gets credit. (This was a
  major fix during v0.1 dev — previous runs missed ~30 tasks the
  agent had genuinely completed.)
- **Process-group cleanup** for setup/eval scripts (`Setpgid: true`
  + `kill -PGID` on timeout). Without this, hung osascript children
  kept open pipes + made our own bench's wait stretch from 30 s
  hard timeout to 90+ s in practice.
- **Optional kinrec recording** (`-record` flag) — mp4 per task,
  saved to `results/<run-stamp>/recordings/`. SIGTERM stop so the
  mp4 trailer (`moov`) writes cleanly.

#### Environment management

- **`warmup.sh`** — pre-bench environment reset:
  1. Force-quit 14 bench-touched apps (Safari / Mail / Notes /
     Calendar / Reminders / Music / Photos / Maps / TextEdit /
     Pages / Numbers / Keynote / System Settings / System Preferences)
  2. Wipe sandbox (`~/Desktop/kinbench/`, `~/.kinbench/`)
  3. Clean KinBench-prefix data in app stores (Notes folder, Reminders
     lists, Calendar events, Mail Drafts, Photos albums, Music playlists)
  4. Probe each app via osascript with a 5-second timeout. Reports
     ✓ healthy / ⚠ HUNG / ✗ TCC DENIED.
  5. `kinrec` recording probe (Screen Recording TCC).
- **`make warmup`** standalone target.
- **`make bench` auto-runs warmup** unless `SKIP_WARMUP=1` is set
  (for fast eval-iteration loops where you don't want state nuked).
- **`make bench-fast`** — bench without warmup (alias of
  `SKIP_WARMUP=1 make bench`).

#### Documentation

- **`README.md`** — positioning + quickstart + first reference
  score + isolation/warmup explanation + comparison table vs
  OSWorld / WebArena / AndroidWorld / WindowsAgentArena.
- **`AUTHOR_GUIDE.md`** — schema reference + author guide for
  writing new tasks. Three-file pattern (task.json + setup.sh +
  eval.sh + optional teardown.sh), eval primitives by category,
  difficulty taxonomy, the don'ts (no LLM-as-judge, no Python in
  setup/eval, no untimed osascript).
- **`ROADMAP.md`** — 50 → 369 task plan + minor-version cadence
  (v0.1 → v0.2 in ~1 month, v1.0 by end-of-year), methodology
  stability commitments, "what we will / won't claim" ladder.

#### Stub generator

- **`cmd/gen-stubs/`** — one-shot Go program that emits the 319
  stub task.json files from inline data. Idempotent (won't clobber
  implemented tasks with full setup/eval).

### Methodology

Inspired by [OSWorld](https://github.com/xlang-ai/OSWorld) (Apache
2.0): same three-file pattern (`task.json` + `setup.sh` + `eval.sh`),
same difficulty taxonomy, same evaluator-script-exits-with-status
contract. All task content + runner implementation here are original.

### What we explicitly do NOT claim (v0.1)

- ❌ "**THE** macOS computer-use benchmark" — too early; we're the
  first publicly published one we know of, but acknowledge others
  may emerge or have been built behind closed doors at major labs.
- ❌ "kinclaw scores X% on macbench" without specifying whether X is
  IMPLEMENTED or STRICT. Both must be reported.
- ❌ "Reflects all macOS workflows" — 369 slots across 15 categories
  is the design target; only 150 are runnable in v0.1.
- ❌ "kinclaw is the best macOS agent" — only one agent backend is
  wired up. Cross-agent comparison comes in v0.2.

### Known limitations (v0.1)

- **Some tasks require infrastructure macOS doesn't expose cleanly
  to bash:** Pages/Numbers/Keynote document inspection (binary
  plist + protobuf), Photos library queries, Maps state. These are
  marked stubs deliberately — implementation deferred to v0.2.
- **Mail tasks are sparse** (1 / 40 implemented). Operating on a
  real user's Mail account during benchmark requires careful test-data
  isolation that v0.1 doesn't provide. v0.2 work.
- **No CI** — needs a Mac runner with TCC pre-granted. GitHub Actions
  macos runners can't be granted programmatically. Self-hosted Mac
  mini in CI is the path; v0.3 or v1.0.
- **No multi-agent backends** — only kinclaw is wired up. WebArena /
  OSWorld adapters for cross-platform validation are designed in
  the kinclaw repo's `benchmarks/` directory but not implemented.
- **Token / cost tracking** — most agents don't expose this
  uniformly. Punted to v0.2.

### Bugs found + fixed during v0.1 development

A multi-hour benchmark debugging session surfaced these. Documenting
them here as a hardening checklist for v0.2:

- **`${VAR,,}` lowercasing in eval scripts** — bash 4+ syntax;
  macOS still ships bash 3.2 by default. Fixed by switching to
  `tr '[:upper:]' '[:lower:]'`. (Hit 4 task evals: 011, 017, 020, 025.)
- **`head -n -N` (negative count) for trimming** — GNU-only;
  BSD/macOS head doesn't support it. Fixed by switching to
  `unzip -l ... | grep -E '[[:space:]]<filename>$'` direct match.
- **`runScript` 30 s timeout too tight for AppleScript cold-starts**
  — Calendar AppleScript first-call took up to 60 s. Bumped to 60 s
  in runner.
- **Eval was skipped on exec timeout**, missing tasks the agent
  had completed before being killed. Fixed: eval always runs.
- **Mid-run app degradation** — Notes / Calendar / Reminders
  accumulate AppleScript hangs after 5-10 calls. Fixed by per-task
  PID-snapshot isolation.
- **`sudo Password:` blocking** — task 271 (energy-saver) tried
  `sudo pmset` and prompted for password; macbench has no way to
  type it, so the agent hangs. Recommended fix: macbench soul should
  block sudo, or task prompt should explicitly say "no sudo". v0.2.

### License

MIT. See `LICENSE`. Three-file pattern + difficulty taxonomy
inspired by OSWorld (Apache-2.0).
