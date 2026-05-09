# macbench

**The first publicly published macOS-native computer-use benchmark
for autonomous agents.** As far as we know.

```
369 task slots defined        ← matches OSWorld's task count exactly
 50 implemented (v0.1)         ← runnable today
319 stubbed (v0.1)             ← real prompts + categories; no setup.sh / eval.sh yet
                                 → filled in progressively v0.2 → v1.0

15 categories            Finder · Safari · Mail · Notes · Calendar ·
                         Reminders · Settings · Terminal · Pages ·
                         Numbers · Keynote · Music · Photos · Maps ·
                         Multi-app
3 difficulty tiers       T1 single-step  ·  T2 multi-step  ·  T3 cross-app
agent-agnostic           any binary that takes a prompt → drives macOS
```

## First reference score (v0.1.0, 2026-05-08)

```
kinclaw v1.15.0 + Kimi-K2.5(cloud) on macbench v0.1
  IMPLEMENTED:  101 / 150  =  67.3%
  STRICT:       101 / 369  =  27.4%   (stubs count as fail)
  Total time:   ~95 minutes (with per-task isolation)
```

For context (these benchmark different OS surfaces, so they're not
directly comparable, but it's the closest cross-comparison available):

| Agent + Brain | Benchmark | Score |
|---|---|---|
| **kinclaw v1.15.0 + Kimi-K2.5** | **macbench v0.1 (macOS)** | **67.3% IMPLEMENTED / 27.4% STRICT** |
| Anthropic Computer Use (Claude Sonnet 4) | OSWorld-Verified (Ubuntu) | ~38% |
| GPT-4o + Set-of-Mark | OSWorld | ~12-15% |

The categories where kinclaw was strongest: Finder (28/39 ≈ 72%),
Reminders (75%), Settings (~68%), Calendar (>50% post-isolation).
Notes / Mail / Pages / Numbers / Keynote are weakest — partly real
agent limitations, partly v0.1 task-design choices (some require
infrastructure beyond bash + AppleScript that's deferred to v0.2).

## Two scores, both honest

When you run the suite, the runner reports two separate pass rates:

- **`IMPLEMENTED: P / I (X.X%)`** — passed P of I tasks that have
  setup.sh + eval.sh, ignoring stubs. The "interesting" score: what
  the agent did against tasks it could actually try.
- **`STRICT: P / 369 (Y.Y%)`** — passed P of 369 total task slots,
  stubs counted as fail. The "long-game" score: progress against
  the full benchmark including unimplemented work.

Both numbers go in `run.json`. Leaderboards / blog posts must report
both — STRICT alone hides agent capability behind v0.1's incomplete
implementation; IMPLEMENTED alone hides how much benchmark is missing.

## Per-task isolation

The runner snapshots PIDs of bench-touched apps (Safari, Mail, Notes,
Calendar, Reminders, Music, Photos, Maps, TextEdit, Pages, Numbers,
Keynote, System Settings) at startup. Between every task, it kills
**only the PIDs the bench itself spawned**, leaving any pre-existing
user instance untouched. This:

1. Prevents the "agent does 5 tasks worth of work in one prompt"
   pollution we observed in the first run (root cause was actually
   pilot-soul memory + reuse of the same Safari window across tasks).
2. Stops Notes / Calendar / Reminders from accumulating AppleScript
   hangs after ~5-10 invocations.
3. Doesn't nuke the user's pre-existing app windows — if you're
   running bench while Safari is open with your work, that Safari
   stays alive.

The startup line `(isolation: N pre-existing PIDs across 14 apps will
be preserved)` confirms the snapshot was captured.

## Warmup

`./warmup.sh` (or `make warmup`) does four things before bench:

1. Force-quit every app the bench touches (so PID snapshot starts
   empty — strongest isolation).
2. Wipe the bench sandbox (`~/Desktop/kinbench/`, `~/.kinbench/`).
3. Clean any KinBench-prefix data in app data stores (Notes /
   Reminders / Calendar / Mail / Photos / Music — leftover from
   prior runs that crashed before teardown).
4. Probe each app via osascript with a 5-second timeout. Reports
   ✓ healthy / ⚠ HUNG / ✗ TCC denied per app.

`make bench` auto-runs warmup. Set `SKIP_WARMUP=1` to skip (useful
during eval-script iteration when you don't want to nuke state).

[OSWorld](https://github.com/xlang-ai/OSWorld) (NeurIPS 2024) is the de
facto standard for desktop computer-use agents — but it benchmarks
inside an Ubuntu/Windows VM. **Nobody has published a comparable
benchmark for macOS native apps.** macbench fills that gap.

## Why this exists

- Apple Intelligence is rolling out, but Apple hasn't published a
  benchmark for measuring agent capability on Mac.
- The OSWorld leaderboard tells you Claude Sonnet 4 hits ~38% on
  Linux desktop tasks. It tells you nothing about how the same model
  drives Finder, Mail, Calendar, Notes, System Settings — apps people
  *actually use* on Macs.
- macbench measures that. Same three-file pattern as OSWorld
  (`task.json` + `setup.sh` + `eval.sh`), same evaluator-script
  philosophy. Different OS surface.

## What it tests

Each task is a natural-language prompt — exactly what a user would
type into a chat box — that the agent must complete by driving real
macOS apps. The eval is deterministic: filesystem state, `defaults`
read, sqlite queries, AppleScript Automation queries. No "ask another
LLM if it looks right".

Sample tasks (all 50 in [`tasks/`](tasks/)):

| ID | Category | Difficulty | What |
|---|---|---|---|
| 001 | finder | T1 | Rename a file |
| 005 | finder | T2 | Compress 3 files into a zip |
| 011 | safari | T1 | Search Google for a phrase |
| 016 | mail | T1 | Compose a draft (don't send) |
| 018 | calendar | T1 | Create event tomorrow at 12:30 PM |
| 021 | settings | T2 | Turn on Do Not Disturb |
| 029 | multi-app | T3 | Take screenshot → attach to draft email |
| 048 | multi-app | T3 | Find file in Finder → email it as attachment |
| 050 | multi-app | T3 | Pages doc → export as PDF |

See [`tasks/`](tasks/) for the full set, and
[`AUTHOR_GUIDE.md`](AUTHOR_GUIDE.md) for the schema if you want to
write more.

## Quickstart

You need:
- macOS 14+ (Sonoma or newer)
- Go 1.22+ (only to compile the runner; tasks themselves are shell + AppleScript)
- An agent binary that takes a prompt and drives macOS — e.g.
  [kinclaw](https://github.com/LocalKinAI/kinclaw), or a wrapper script
  around any vision-LLM-driven framework

```bash
# 1. Clone + build
git clone https://github.com/LocalKinAI/macbench
cd macbench
make build

# 2. One-time AppleScript Automation TCC priming (Mail / Notes /
#    Calendar / Reminders / Safari) — click "Allow" on each popup
make warmup

# 3. Run the benchmark with your agent
make bench AGENT=/path/to/kinclaw \
           AGENT_ARGS='-soul pilot.soul.md -exec {prompt}'

# Or: just N tasks
make bench AGENT=./kinclaw AGENT_ARGS='-exec {prompt}' TASKS=001,005,016

# Or: with screen recording (mp4 per task)
make bench-record AGENT=./kinclaw AGENT_ARGS='-exec {prompt}'
```

Output:

```
macbench: 50 task(s), agent=kinclaw, args="-soul pilot.soul.md -exec {prompt}", record=false
──────────────────────────────────────────────────────────────────────
  ✓ 001-finder-rename              T1   1284ms
  ✓ 002-safari-open-url            T1   3122ms
  ✗ 005-finder-zip                 T2   8941ms [eval] expected ≥3 files in archive
  ...
──────────────────────────────────────────────────────────────────────
PASSED: 19 / 50  (38.0%)
→ wrote results/20260508-141530/run.json
```

Per-task report saved to `results/<timestamp>/run.json`. If
`-record` was on, mp4s land in `results/<timestamp>/recordings/`.

## How the agent is invoked

`-agent-args` is a template. The literal string `{prompt}` gets
replaced with the task's natural-language prompt at run time.
Tokens are split on whitespace (no shell quoting), so each `{prompt}`
becomes exactly one argv slot.

```bash
# kinclaw (LocalKinAI agent)
-agent kinclaw \
-agent-args "-soul pilot.soul.md -exec {prompt}"

# Anthropic Computer Use wrapper (hypothetical)
-agent anthropic-cua \
-agent-args "--task {prompt} --max-tokens 4096"

# Any custom shell wrapper
-agent ./my-wrapper.sh \
-agent-args "{prompt}"
```

If your agent's CLI shape isn't expressible as a single template, write
a 3-line shell wrapper. macbench treats the agent as a black box.

## Permissions

macbench tasks drive real macOS apps, so your **agent binary** needs:

1. **Accessibility** — System Settings → Privacy & Security →
   Accessibility → toggle on.
2. **Screen Recording** — same screen, Screen Recording → on.
3. **AppleScript Automation** for Mail / Notes / Calendar / Reminders /
   Safari / System Events. `make warmup` triggers any missing dialogs
   in one batch.
4. **(optional) Screen Recording for `kinrec`** — only if you use
   `make bench-record`. The kinrec binary needs its own grant.

All grants are one-time; macOS remembers per code-signing identity.

## Comparison with related benchmarks

| | macbench | [OSWorld](https://github.com/xlang-ai/OSWorld) | [WebArena](https://github.com/web-arena-x/webarena) | [AndroidWorld](https://github.com/google-research/android_world) | [WindowsAgentArena](https://github.com/microsoft/WindowsAgentArena) |
|---|---|---|---|---|---|
| Platform | **macOS native** | Ubuntu / Windows VM | Browser only | Android emulator | Windows VM |
| Total task slots | **369** | 369 | ~800 | ~116 | ~150 |
| Implemented (v0.1) | 50 | 369 | 800+ | 116 | 150 |
| Eval style | filesystem + `defaults` + AppleScript + sqlite | filesystem + ROS + screenshot match | DOM + side-effect | UI tree + side-effect | filesystem + registry |
| Agent contract | exec(prompt) → drive macOS | VNC channel into VM | browser DOM API | adb-style | RDP-style |
| First public release | 2026 | 2024 | 2023 | 2024 | 2024 |

We borrow OSWorld's three-file pattern and difficulty taxonomy, but
the implementation is original.

## What's missing in v0.1

- **319 stub tasks need setup.sh + eval.sh** — every stub already has
  a real, specific prompt and a well-thought category/difficulty
  assignment; what's missing is the deterministic eval. See
  [`ROADMAP.md`](ROADMAP.md) for the per-category implementation
  schedule across v0.2 → v1.0.
- **Anthropic / OpenAI / open-source agent backends.** Right now we've
  only run the suite with [kinclaw](https://github.com/LocalKinAI/kinclaw);
  contributions wiring up other agents are first-class welcome.
- **CI** — needs a Mac runner with TCC pre-granted. GitHub Actions
  macos runners can't be granted programmatically, so this requires
  a self-hosted Mac mini. Probably v0.3 or v1.0.
- **Token / cost tracking** — most agents don't expose this uniformly.
  Punted to v0.2.
- **Leaderboard site.** The README will start carrying numbers as we
  collect them.

### Implementing a stub

```bash
# 1. Pick a stub from tasks/ — its task.json has the spec
cat tasks/051-finder-show-hidden-files/task.json

# 2. Write setup.sh + eval.sh per AUTHOR_GUIDE.md
$EDITOR tasks/051-finder-show-hidden-files/setup.sh
$EDITOR tasks/051-finder-show-hidden-files/eval.sh
chmod +x tasks/051-finder-show-hidden-files/{setup,eval}.sh

# 3. Remove the "stub" status field from task.json
$EDITOR tasks/051-finder-show-hidden-files/task.json

# 4. Verify standalone (per AUTHOR_GUIDE.md self-check)
cd tasks/051-finder-show-hidden-files
bash setup.sh
# (manually do what the prompt says)
bash eval.sh && echo PASS

# 5. Open a PR
```

## License

MIT. See [LICENSE](LICENSE).

The three-file evaluator pattern + difficulty taxonomy are inspired by
[OSWorld](https://github.com/xlang-ai/OSWorld) (Apache-2.0); all task
content + runner implementation here are original.

## See also

- [kinclaw](https://github.com/LocalKinAI/kinclaw) — Pure-Go macOS
  computer-use agent. The reference implementation that drives this
  benchmark.
- [OSWorld](https://os-world.github.io) — the inspiration. If you're
  benchmarking on Linux/Windows, use that.
- [`AUTHOR_GUIDE.md`](AUTHOR_GUIDE.md) — how to write a new task.
- [`ROADMAP.md`](ROADMAP.md) — path from 50 → 369.
