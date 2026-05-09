# macbench roadmap

**Target: 369 task slots, all implemented** — matching
[OSWorld](https://github.com/xlang-ai/OSWorld)'s shipped count, so
cross-benchmark methodological comparisons are defensible.

**Status (v0.1):** all 369 task **slots** are designed; 50 are
implemented (have `setup.sh` + `eval.sh`), 319 are stubbed (real
prompt + category, no scripts yet). Filling in stubs is the
v0.1 → v1.0 work.

```
v0.1 (2026-05, shipped)         50 implemented + 319 stubs = 369 slots  ← here
v0.2 (target 2026-06)          100 implemented + 269 stubs
v0.3 (target 2026-08)          200 implemented + 169 stubs
v0.5 (target 2026-10)          300 implemented +  69 stubs
v1.0 (target 2026-12)          369 implemented +   0 stubs               ← parity
```

Each minor bump is roughly 30-50 stubs implemented per month, plus
contributions from the community.

## Where the 369 slots are distributed

All 15 categories are represented in v0.1; only the implementation
density varies.

| Category | v0.1 implemented | v0.1 stubs | Total slots | Eval primitives |
|---|---|---|---|---|
| **Finder** | 10 | 40 | **50** | filesystem, xattr, sqlite (Spotlight) |
| **Safari** | 6 | 34 | **40** | AppleScript URL/window, history.db, Bookmarks.plist |
| **Mail** | 1 | 39 | **40** | AppleScript drafts/inbox/flags, Envelope Index sqlite |
| **Notes** | 5 | 25 | **30** | AppleScript notes (body HTML strip + substring) |
| **Calendar** | 6 | 29 | **35** | AppleScript events + dates |
| **Reminders** | 3 | 22 | **25** | AppleScript lists/reminders/due dates |
| **Settings** | 7 | 43 | **50** | `defaults read`, `defaults -currentHost`, plists |
| **Terminal** | 5 | 15 | **20** | filesystem of agent-created files |
| **Pages** | 1 | 14 | **15** | bundle inspection + AppleScript doc dictionary |
| **Numbers** | 1 | 14 | **15** | AppleScript table cell access |
| **Keynote** | 0 | 10 | **10** | AppleScript presentation/slide queries |
| **Music** | 0 | 10 | **10** | AppleScript player state, library access |
| **Photos** | 0 | 10 | **10** | AppleScript album/asset queries |
| **Maps** | 0 | 5 | **5** | AppleScript directions/search |
| **Multi-app (T3)** | 5 | 9 | **14** | composed evals from above |
| **Total** | **50** | **319** | **369** | |

Distribution rationale: macOS native apps Apple ships, weighted by
real-world usage frequency. Settings + Mail + Finder get the largest
counts because that's where the most distinct verbs live.

## Difficulty mix (target)

OSWorld shipped roughly 25% T1, 50% T2, 25% T3. macbench v0.1 is
heavy on T2 (66%) and light on T3 (10%) because cross-app workflows
are the most expensive to design well. Target for v1.0:

| Tier | v0.1 | Target | What |
|---|---|---|---|
| T1 (single-app, single-step) | 11 (22%) | 80-100 (22-27%) | "Rename foo.txt to bar.txt" |
| T2 (single-app, multi-step) | 34 (68%) | 200-220 (54-60%) | "Sort folder + tag the top 5" |
| T3 (cross-app, semantic) | 5 (10%) | 60-90 (16-25%) | "Find email → add to Calendar" |

## Contribution slots

Open issues (once we go public) will be one issue per missing task,
labeled by category. Volunteer guide is in
[`AUTHOR_GUIDE.md`](AUTHOR_GUIDE.md).

A good contribution:
- Doesn't change the eval logic of an existing passing task without
  a regression suite to back it up
- Comes with proof of working setup → manual-do → eval pass round-trip
- Has a teardown that doesn't pollute user state if the agent left
  things half-done

## Methodology stability commitments

These will not change between v0.1 and v1.0:

1. **Three-file pattern** — `task.json` + `setup.sh` + `eval.sh` (+
   optional `teardown.sh`). Stable.
2. **Eval is a script that exits 0 on pass, non-zero on fail.** No
   meta-evaluators. No "ask another LLM if the screenshot looks right".
3. **Agent contract is exec(prompt) → drives macOS for some bounded
   time → exits.** State is observed externally via filesystem /
   `defaults` / sqlite / AppleScript. The agent's internal log /
   reasoning trace is irrelevant to the score.
4. **Difficulty tags (T1/T2/T3) are stable** — once a task ships at
   T2, it stays T2. New tasks slot in.

What CAN change between minor versions:

- Specific eval logic of a task (if a bug is found in the evaluator
  itself — but pass rates from prior runs become invalid; we'll bump
  major version)
- Per-task default timeout
- Setup fixture details (provided eval still passes the agent that
  was passing before)

## What v0.1 explicitly does NOT claim

- ❌ "**THE** macOS computer-use benchmark" — too early, we've
  implemented only 50 of the 369 slots. We are *the first publicly
  published* one we know of, but others may emerge or have been
  built behind closed doors at major labs.
- ❌ "kinclaw scores X% on macbench" — without specifying whether X is
  the IMPLEMENTED or STRICT score. Both must be reported.
- ❌ "Reflects all macOS workflows" — 369 slots across 15 categories
  is the design target; only 50 are runnable today. Until v1.0 a lot
  of the design space is on paper.
- ❌ "kinclaw scores X% therefore kinclaw is the best agent" — we've
  only run the kinclaw backend. Once Anthropic CUA / OpenAI CUA
  backends are wired up (v0.2), we'll have cross-agent numbers worth
  comparing.

## When we'll claim more

- **At v0.2** ("100 tasks + 2-3 agents benchmarked"): we'll publish
  numbers in the README and on a leaderboard page. Blog post.
- **At v0.3** ("200 tasks + 5+ agents"): community traction; this
  becomes the de facto Mac standard or it doesn't.
- **At v1.0** ("369 tasks + CI + cross-agent leaderboard"): we'll
  campaign for this to be cited in computer-use papers as the macOS
  counterpart to OSWorld.

## Versioning rule

- v0.1.x — patch a bug in an existing task's eval (bumps version,
  invalidates affected scores from prior runs)
- v0.2.0 — meaningful task additions (50→100); existing scores still
  comparable on the v0.1 subset
- v1.0 — 369 task floor reached; first stable benchmark snapshot

The leaderboard page (when it exists) will tag every score with the
version it was run on, so cross-time comparisons are honest.
