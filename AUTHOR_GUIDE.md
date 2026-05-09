# kin-bench task author guide

Adding a task takes ~20 minutes if you follow the template. The
hardest part is writing a deterministic `eval.sh` — start there.

## The 3-file pattern

```
tasks/<NNN-slug>/
  task.json        ← metadata + the natural-language prompt
  setup.sh         ← write fixtures, reset state — runs BEFORE agent
  eval.sh          ← validate post-state — exit 0 = pass, anything else = fail
  teardown.sh      ← optional — restore user state, runs whether pass/fail
```

NNN is a zero-padded 3-digit ID. Use slug-style folder names:
`007-mail-search-by-subject`, not `007 Mail Search`.

## task.json schema

```json
{
  "id":          "007-mail-search-by-subject",
  "category":    "mail",
  "difficulty":  "T2",
  "prompt":      "In Mail, find the email with subject 'Receipt' and reply 'Got it, thanks'",
  "timeout_sec": 120,
  "soul":        "souls/pilot.soul.md"
}
```

| Field | Required | Notes |
|---|---|---|
| `id` | yes | Should match folder name. Used for filtering (`-tasks 007`). |
| `category` | yes | One of: `finder`, `safari`, `mail`, `notes`, `calendar`, `settings`, `terminal`, `pages`, `numbers`, `music`, `multi-app` |
| `difficulty` | yes | `T1` (single-app single-step), `T2` (single-app multi-step), `T3` (cross-app / semantic) |
| `prompt` | yes | Natural language. Don't leak benchmark structure ("This is task 7"). |
| `timeout_sec` | no | Default 90s. Override if the task genuinely needs more (multi-app workflows). |
| `soul` | no | Default `souls/pilot.soul.md`. Override only if you need a specialized soul. |

## setup.sh contract

- Runs from the task directory (cwd is the task folder).
- Has 30 seconds total; should finish in <2.
- Writes fixtures into a sandbox path:
  - Files: `~/Desktop/kinbench/<NNN>-...`
  - Persistent state: `~/.kinbench/<NNN>-...`
- **Never modifies user state without saving and restoring it**.
  If you change a `defaults` value or a Notes entry, save the original
  in `~/.kinbench/<NNN>-orig-*` and restore in `teardown.sh`.
- Idempotent: running it twice from a clean state should leave the
  same result. Don't append; overwrite.
- Exit 0 on success.

## eval.sh contract

- Pure observation. Don't write to user state.
- Has 30 seconds total.
- Exit 0 = pass; any non-zero = fail.
- Print one human-readable line summarizing what it observed.
- Last printed reason becomes the failure annotation in the results
  table.

### Eval primitives by category

| Category | Cheap eval primitive |
|---|---|
| `finder` | `ls`, `stat`, `unzip -l`, `shasum` on files |
| `safari` | `osascript` reading `URL of front document` |
| `mail` | `osascript` (`subject of every message of inbox`) — needs Mail Automation TCC perm |
| `notes` | `osascript` (`every note whose name = "..."`) — needs Notes Automation perm |
| `calendar` | `osascript` (`every event whose summary = "..."`) — needs Calendar perm |
| `settings` | `defaults read -g <KEY>` (no permission needed) |
| `terminal` | `cat`, `grep` on files agent created |
| `multi-app` | Compose two of the above |

**AX as fallback eval**: if AppleScript / `defaults` doesn't expose
what you want, shell out to `kinax`:
```bash
~/.localkin/bin/kinax attr AXMain --bundle com.apple.Safari
```
But prefer AppleScript / sqlite / defaults — they're more robust to
macOS UI changes.

## teardown.sh contract (optional)

- Runs after eval, regardless of pass/fail.
- Has 30 seconds total.
- Restore user-visible state (delete created files, switch back to
  Light mode, etc.). **Do NOT delete sandbox fixtures other tests
  might use.**
- Best-effort — if it fails, the test still counts as pass/fail by
  what eval.sh said.

## Difficulty curve target (v0.1, 50 tasks shipped)

| Tier | Count | Examples |
|---|---|---|
| **T1 easy** | 12 | Rename file. Open URL. Create note. Toggle setting. |
| **T2 medium** | 33 | Sort folder. Tag file. Edit Calendar event. Compress folder. |
| **T3 hard** | 5 | Find file → attach to email. Spotlight → Calendar. Pages → PDF. |

Actual category distribution in v0.1:

| Category | Tasks |
|---|---|
| Finder | 10 |
| Safari | 6 |
| Notes | 5 |
| Mail | 1 |
| Calendar | 6 |
| Settings | 7 |
| Terminal | 5 |
| Pages / Numbers | 2 |
| Reminders | 3 |
| Multi-app | 5 |

## Common eval pitfalls

- **Race conditions**: agent may still be finishing when eval runs.
  If you see flaky passes, add `sleep 1` at the top of eval.sh, but
  prefer task prompts that don't need this.
- **AppleScript automation TCC**: first time you eval a Mail/Notes/
  Calendar task, macOS will prompt the user to grant `osascript`
  automation access. Grant it once, then it's silent forever. CI
  needs pre-granted Mac runners.
- **Notes sync delay**: iCloud Notes may show in `(every note)`
  before iCloud syncs, but the *recently created* note may take
  ~1-2s to appear. Add `sleep 2` in eval.sh for Notes tests.
- **Safari dictionary deprecation rumor**: Safari 18+ may restrict
  the AppleScript dictionary. As of macOS 26.3 it still works. If
  it breaks, fall back to `kinax attr AXMain --bundle com.apple.Safari`.

## Self-check before committing a task

```bash
# 1. Setup → manual-do → eval → teardown, by hand
cd tasks/<your-task>
bash setup.sh
# (manually do what the prompt says — pretend you're the agent)
bash eval.sh
echo "exit=$?"   # should be 0
[[ -f teardown.sh ]] && bash teardown.sh

# 2. Drive your task through the harness with a "no-op" fake agent
#    to prove eval correctly fails when the agent doesn't act:
cat > /tmp/noop-agent.sh <<'EOF'
#!/usr/bin/env bash
sleep 1; exit 0
EOF
chmod +x /tmp/noop-agent.sh
go run . -agent /tmp/noop-agent.sh -agent-args '{prompt}' -tasks <NNN>
# Expected: ✗ [eval] — eval correctly catches that nothing happened.

# 3. Drive it with a "cheat" agent that performs the side effect
#    directly — proves the harness PASS path works:
cat > /tmp/cheat-agent.sh <<'EOF'
#!/usr/bin/env bash
# extend per task — example for 001-finder-rename:
mv "$HOME/Desktop/kinbench/001-input.txt" "$HOME/Desktop/kinbench/001-output.txt"
exit 0
EOF
chmod +x /tmp/cheat-agent.sh
go run . -agent /tmp/cheat-agent.sh -agent-args '{prompt}' -tasks <NNN>
# Expected: ✓ — eval sees the side effect and passes.

# Only commit a task when both 2 and 3 give the right answer.
```
