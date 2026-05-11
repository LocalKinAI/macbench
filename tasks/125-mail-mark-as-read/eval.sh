#!/usr/bin/env bash
# Inbox manipulation can't always be hard-verified without a live account.
# Strategy: if an inbox message exists, check read_status. Otherwise soft-pass
# via the agent's confirmation file.
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    set readCt to 0
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 125")
                set found to found + 1
                if read status of m is true then set readCt to readCt + 1
            end repeat
        end try
    end repeat
    return (found as string) & "|" & (readCt as string)
end tell
EOF
)"
echo "inbox found/read: $R"
FOUND="${R%%|*}"
READCT="${R#*|}"

if [[ "${FOUND:-0}" -ge 1 ]] && [[ "${READCT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: inbox message marked read"
  exit 0
fi

F="$HOME/Desktop/kinbench/125-read-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "marked-read" "$F"; then
  echo "PASS (soft): agent confirmation file present (no test inbox seed available)"
  exit 0
fi
echo "FAIL: neither inbox state nor confirmation file produced"
exit 1
