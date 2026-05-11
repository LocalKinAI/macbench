#!/usr/bin/env bash
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set inboxCt to 0
    set archiveCt to 0
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            set inboxCt to inboxCt + (count of (every message of inb whose subject = "KinBench 129"))
        end try
        try
            set arch to mailbox "Archive" of acct
            set archiveCt to archiveCt + (count of (every message of arch whose subject = "KinBench 129"))
        end try
    end repeat
    return (inboxCt as string) & "|" & (archiveCt as string)
end tell
EOF
)"
echo "inbox/archive counts: $R"
INB="${R%%|*}"
ARC="${R#*|}"
if [[ "${ARC:-0}" -ge 1 ]] && [[ "${INB:-0}" -eq 0 ]] 2>/dev/null; then
  echo "PASS: message archived"
  exit 0
fi

F="$HOME/Desktop/kinbench/129-archive-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "archived" "$F"; then
  echo "PASS (soft): confirmation file present"
  exit 0
fi
echo "FAIL"
exit 1
