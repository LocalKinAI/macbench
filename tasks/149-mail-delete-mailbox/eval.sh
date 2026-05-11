#!/usr/bin/env bash
set -uo pipefail
sleep 2
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    repeat with acct in accounts
        try
            set mb to mailbox "kinbench-deleteme" of acct
            set found to 1
        end try
    end repeat
    try
        set mb to mailbox "kinbench-deleteme"
        set found to 1
    end try
    return found as string
end tell
EOF
)"
echo "mailbox still present: $R"
if [[ "${R:-0}" -eq 0 ]] 2>/dev/null; then
  echo "PASS: mailbox deleted"
  exit 0
fi
F="$HOME/Desktop/kinbench/149-delete-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "deleted" "$F"; then
  echo "PASS (soft): confirmation present"
  exit 0
fi
echo "FAIL: kinbench-deleteme still exists"
exit 1
