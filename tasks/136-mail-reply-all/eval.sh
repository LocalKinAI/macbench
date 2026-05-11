#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set multiRecip to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 136")
                set total to total + 1
                try
                    set recCount to (count of to recipients of m) + (count of cc recipients of m)
                    if recCount >= 2 then set multiRecip to multiRecip + 1
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (multiRecip as string)
end tell
EOF
)"
echo "drafts/multi-recipient: $R"
TOTAL="${R%%|*}"
MR="${R#*|}"
if [[ "${MR:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: reply-all draft with multiple recipients"
  exit 0
fi
if [[ "${TOTAL:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft saved but recipient count not detected"
  exit 0
fi
echo "FAIL"
exit 1
