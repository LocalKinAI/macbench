#!/usr/bin/env bash
set -uo pipefail
sleep 3

RESULT="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench Share 167")
            set total to total + (count of drafts)
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "drafts found with subject 'KinBench Share 167': $RESULT"
[[ "${RESULT:-0}" -ge 1 ]] 2>/dev/null && { echo "PASS"; exit 0; }
echo "FAIL: no Mail draft with that subject"
exit 1
