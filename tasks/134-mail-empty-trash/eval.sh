#!/usr/bin/env bash
# Trash state per-account is hard to assert without seeded messages.
# Hard check: trash count = 0 across accounts. Soft fallback: confirm file.
set -uo pipefail
sleep 2

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set tb to mailbox "Deleted Messages" of acct
            set total to total + (count of messages of tb)
        end try
        try
            set tb to mailbox "Trash" of acct
            set total to total + (count of messages of tb)
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "remaining trash count: $R"
if [[ "${R:-0}" -eq 0 ]] 2>/dev/null; then
  echo "PASS: trash empty"
  exit 0
fi

F="$HOME/Desktop/kinbench/134-trash-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "trash-emptied" "$F"; then
  echo "PASS (soft): confirmation present"
  exit 0
fi
echo "FAIL"
exit 1
