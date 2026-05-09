#!/usr/bin/env bash
# Pass: ≥1 message in any account's Drafts mailbox with our subject.
# (Saving as draft happens automatically when Mail's compose window
# stays open / loses focus / is explicitly saved.)
#
# Note: agents that hit Cmd+S then close the compose window will
# trigger Mail to flush the draft; agents that just leave it open
# may not flush — give them up to 3s of grace.
set -uo pipefail
sleep 3

COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set total to total + (count of (every message of draftBox whose subject = "KinBench 016 Test"))
        end try
    end repeat
    return total
end tell
EOF
)"

echo "drafts matching subject 'KinBench 016 Test': $COUNT"
if [[ -z "$COUNT" ]]; then
  echo "FAIL: AppleScript query failed (Mail not granted Automation?)"
  exit 1
fi
if [[ "$COUNT" -ge 1 ]]; then
  echo "PASS: draft saved"
  exit 0
fi
echo "FAIL: no draft with our subject found"
exit 2
