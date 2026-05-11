#!/usr/bin/env bash
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    set unreadCt to 0
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 126")
                set found to found + 1
                if read status of m is false then set unreadCt to unreadCt + 1
            end repeat
        end try
    end repeat
    return (found as string) & "|" & (unreadCt as string)
end tell
EOF
)"
echo "inbox found/unread: $R"
FOUND="${R%%|*}"
UC="${R#*|}"
if [[ "${FOUND:-0}" -ge 1 ]] && [[ "${UC:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: inbox message marked unread"
  exit 0
fi

F="$HOME/Desktop/kinbench/126-unread-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "marked-unread" "$F"; then
  echo "PASS (soft): agent confirmation file present"
  exit 0
fi
echo "FAIL: no proof of action"
exit 1
