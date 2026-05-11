#!/usr/bin/env bash
set -uo pipefail
sleep 2
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    repeat with acct in accounts
        try
            set mb to mailbox "kinbench-test-mailbox" of acct
            set found to 1
            exit repeat
        end try
    end repeat
    try
        set mb to mailbox "kinbench-test-mailbox"
        set found to 1
    end try
    return found as string
end tell
EOF
)"
echo "mailbox found: $R"
if [[ "${R:-0}" -eq 1 ]] 2>/dev/null; then
  echo "PASS: mailbox created"
  exit 0
fi
F="$HOME/Desktop/kinbench/147-create-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "kinbench-test-mailbox" "$F"; then
  echo "PASS (soft): confirmation file present"
  exit 0
fi
echo "FAIL"
exit 1
