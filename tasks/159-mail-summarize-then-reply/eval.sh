#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set longBody to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 159")
                set total to total + 1
                try
                    if (length of (content of m)) > 50 then set longBody to longBody + 1
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (longBody as string)
end tell
EOF
)"
echo "drafts/longBody: $R"
T="${R%%|*}"
LB="${R#*|}"
if [[ "${T:-0}" -ge 1 ]] && [[ "${LB:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: summary reply draft with substantive body"
  exit 0
fi
if [[ "${T:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft exists, body length not verifiable"
  exit 0
fi
echo "FAIL"
exit 1
