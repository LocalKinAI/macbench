#!/usr/bin/env bash
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    set flaggedCt to 0
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 127")
                set found to found + 1
                try
                    if flag index of m is 0 then set flaggedCt to flaggedCt + 1
                end try
            end repeat
        end try
    end repeat
    return (found as string) & "|" & (flaggedCt as string)
end tell
EOF
)"
echo "inbox found/red-flagged: $R"
FOUND="${R%%|*}"
FC="${R#*|}"
if [[ "${FOUND:-0}" -ge 1 ]] && [[ "${FC:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: message red-flagged"
  exit 0
fi

F="$HOME/Desktop/kinbench/127-flag-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "flagged-red" "$F"; then
  echo "PASS (soft): agent confirmation file present"
  exit 0
fi
echo "FAIL: neither flag-state nor confirmation file"
exit 1
