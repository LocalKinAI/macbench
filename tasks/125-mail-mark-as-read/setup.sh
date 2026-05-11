#!/usr/bin/env bash
# Soft-pass strategy: seeds a synthetic inbox message via AppleScript if possible.
# If no account exists, agent still produces the confirm file from the prompt.
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/125-read-confirm.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 125")
                set read status of m to false
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ inbox messages 'KinBench 125' (if any) reset to unread; confirm file cleared"
