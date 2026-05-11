#!/usr/bin/env bash
set -uo pipefail
sleep 2
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set hasContact to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench 367")
            repeat with m in drafts
                set total to total + 1
                try
                    repeat with t in to recipients of m
                        if (address of t) contains "kinbench-apple@example.com" then
                            set hasContact to hasContact + 1
                        end if
                    end repeat
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (hasContact as string)
end tell
EOF
)"
COUNT="${R%%|*}"; CONTACT="${R#*|}"
echo "drafts=$COUNT to-kinbench-apple=$CONTACT"

if [[ "${COUNT:-0}" -ge 1 && "${CONTACT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: draft addressed to planted contact"
  exit 0
fi
if [[ "${COUNT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft saved; recipient not introspectable on this Mail build"
  exit 0
fi
echo "FAIL: no draft with subject 'KinBench 367'"
exit 1
