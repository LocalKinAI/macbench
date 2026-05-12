# macbench

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20094244.svg)](https://doi.org/10.5281/zenodo.20094244)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**The first publicly published macOS-native computer-use benchmark
for autonomous agents.** As far as we know.

**Paper:** *macbench: A macOS-Native Computer-Use Benchmark for
Autonomous Agents* — concept DOI [`10.5281/zenodo.20094244`](https://doi.org/10.5281/zenodo.20094244)
(CC-BY-4.0, single PDF bundles EN + 中文; also rendered at
[localkin.dev/papers/macbench](https://www.localkin.dev/papers/macbench)).

```
369 task slots defined        ← matches OSWorld's task count exactly
171 implemented (v0.1.2)       ← runnable today (+11 finder stubs filled 2026-05-10)
198 stubbed (v0.1.2)           ← real prompts + categories; no setup.sh / eval.sh yet
                                 → filled in progressively v0.2 → v1.0
                                 (notes 31/31 ✓ finder 50/50 ✓ remaining: mail, settings, etc.)

15 categories            Finder · Safari · Mail · Notes · Calendar ·
                         Reminders · Settings · Terminal · Pages ·
                         Numbers · Keynote · Music · Photos · Maps ·
                         Multi-app
3 difficulty tiers       T1 single-step  ·  T2 multi-step  ·  T3 cross-app
agent-agnostic           any binary that takes a prompt → drives macOS
```

## Reference scores

### v0.2 (2026-05-11) — paper #11: grep-routed agents

Adds 10 web tasks (380-389) bringing total to **379 tasks**, and
companion releases the grep-router stack (kinclaw `kinthink` + a 478-
action `cerebellum` skill library — see
[paper #11](https://www.localkin.dev/papers/grep-routed-agents)):

```
kinclaw + kinthink + cerebellum + Kimi-K2.6(cloud) on macbench v0.2
  STRICT:       182 / 379  =  48.0%   (incl. web subcategory at 80%)
  Total time:   76 minutes  (avg 12.0 s / task)
  LLM tokens:   ZERO on Layer-0-routed tasks (244 of 379)
```

The cross-OS comparison table updates accordingly:

| Agent + Stack | Benchmark | Score | LLM tokens |
|---|---|---|---|
| **kinclaw + kinthink + Kimi-K2.6** | **macbench v0.2 (macOS)** | **48.0% (182/379)** | **0 on hit path** |
| kinclaw + Kimi-K2.5 (LLM-only, v0.1) | macbench v0.1 (macOS) | 30.4% (112/369) | Full |
| Reference verifier (no LLM, ceiling) | macbench v0.1 (185 cov.) | 84.3% (156/185) | 0 |
| Anthropic Computer Use (Claude Sonnet 4) | OSWorld-Verified (Ubuntu) | ~38% | Full |
| GPT-4o + Set-of-Mark | OSWorld (Ubuntu) | ~12-15% | Full |

**Web subcategory (paper #11's marquee comparison vs OpenAI's Codex
Chrome Extension):** 8/10 PASS, 750 ms average, 0 LLM tokens.

### v0.1 (2026-05-08) — first reference run

```
kinclaw v1.15.0 + Kimi-K2.5(cloud) on macbench v0.1
  IMPLEMENTED:  101 / 150  =  67.3%
  STRICT:       101 / 369  =  27.4%
  Total time:   ~95 minutes
```

The categories where kinclaw was strongest in v0.1: Finder (28/39 ≈ 72%),
Reminders (75%), Settings (~68%), Calendar (>50% post-isolation).
Notes / Mail / Pages / Numbers / Keynote were weakest — partly real
agent limitations, partly v0.1 task-design choices (some required
infrastructure beyond bash + AppleScript that's now in v0.2).

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

## Reference verifier — platform ceiling, no agent

`tools/reference_verifier.sh` runs every notes-category task with a
canonical osascript / shell solution INSTEAD of an agent. Total
runtime: **~100 seconds for all 31 notes tasks**. The PASS rate
this produces is the **platform ceiling** — what's achievable on
this Mac + iCloud combination via direct AppleScript, regardless
of how good the agent is.

```
tools/reference_verifier.sh
  → 21/31 PASS (67.7%) — first reference baseline (2026-05-10)
  → 10 fails are platform timing / AS-dictionary limits (e.g.
    AppleScript `pinned` property removed in macOS 14+,
    Mail draft creation racing with iCloud sync, Notes UI
    keystroke timing variance).
```

Use this to (1) verify eval correctness without burning agent
inference time, (2) distinguish "agent capability gaps" from
"platform-locked tests", (3) iterate eval.sh changes in seconds
not minutes.

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
- macOS 14+ (Sonoma or newer) — macbench itself is intentionally
  macOS-only (its eval scripts use AppleScript + Mac apps). The
  *agent* you point at it can be anything; e.g.
  [kinclaw](https://github.com/LocalKinAI/kinclaw) is now cross-platform
  (macOS / Linux / Windows as of 2026-05-12), but macbench's *tasks*
  measure macOS Finder, Mail, Calendar, Notes, etc., so a Linux build
  of kinclaw won't have anything to drive here. Use the macOS build.
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
