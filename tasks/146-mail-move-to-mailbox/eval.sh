#!/usr/bin/env bash
set -uo pipefail
sleep 2
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    repeat with acct in accounts
        try
            set mb to mailbox "KinBench 146" of acct
            set found to 1
            exit repeat
        end try
    end repeat
    try
        set mb to mailbox "KinBench 146"
        set found to 1
    end try
    return found as string
end tell
EOF
)"
echo "mailbox found: $R"
if [[ "${R:-0}" -eq 1 ]] 2>/dev/null; then
  echo "PASS: mailbox 'KinBench 146' exists"
  exit 0
fi
F="$HOME/Desktop/kinbench/146-move-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "moved-to-folder" "$F"; then
  echo "PASS (soft): agent confirmation present"
  exit 0
fi
echo "FAIL"
exit 1
