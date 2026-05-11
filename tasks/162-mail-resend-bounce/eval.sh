#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set hit to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 162 Resend")
                if (subject of m) contains "Re-sending" then set hit to hit + 1
            end repeat
        end try
    end repeat
    return hit as string
end tell
EOF
)"
echo "matching drafts: $R"
[[ "${R:-0}" -ge 1 ]] 2>/dev/null && { echo "PASS: draft subject modified"; exit 0; }
echo "FAIL: no draft with both 'KinBench 162 Resend' and 'Re-sending'"
exit 1
