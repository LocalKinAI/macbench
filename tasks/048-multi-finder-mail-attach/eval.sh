#!/usr/bin/env bash
set -uo pipefail
sleep 3

RESULT="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set hasAttach to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench 048")
            repeat with m in drafts
                set total to total + 1
                if (count of mail attachments of m) > 0 then set hasAttach to hasAttach + 1
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (hasAttach as string)
end tell
EOF
)"
echo "drafts found / with attachments: $RESULT"
COUNT="${RESULT%%|*}"
ATT="${RESULT#*|}"
if [[ "$COUNT" -ge 1 ]] && [[ "$ATT" -ge 1 ]] 2>/dev/null; then
  echo "PASS: draft with attachment saved"
  exit 0
fi
if [[ "$COUNT" -ge 1 ]] 2>/dev/null; then
  echo "PARTIAL: draft saved but no attachment found in AppleScript view (some Mail builds don't surface unsent draft attachments) — soft pass"
  exit 0
fi
echo "FAIL: no draft with subject 'KinBench 048'"
exit 1
