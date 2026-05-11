#!/usr/bin/env bash
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    set blueCt to 0
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 128")
                set found to found + 1
                try
                    if flag index of m is 4 then set blueCt to blueCt + 1
                end try
            end repeat
        end try
    end repeat
    return (found as string) & "|" & (blueCt as string)
end tell
EOF
)"
echo "inbox found/blue-flagged: $R"
FOUND="${R%%|*}"
BC="${R#*|}"
if [[ "${FOUND:-0}" -ge 1 ]] && [[ "${BC:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: message blue-flagged"
  exit 0
fi

F="$HOME/Desktop/kinbench/128-flag-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "flagged-blue" "$F"; then
  echo "PASS (soft): agent confirmation file present"
  exit 0
fi
echo "FAIL"
exit 1
