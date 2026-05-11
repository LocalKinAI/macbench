#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set total to total + (count of (every message of draftBox whose subject contains "KinBench 135"))
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "matching drafts: $R"
[[ "${R:-0}" -ge 1 ]] 2>/dev/null && { echo "PASS: reply draft saved"; exit 0; }
echo "FAIL: no draft matching 'KinBench 135'"
exit 1
