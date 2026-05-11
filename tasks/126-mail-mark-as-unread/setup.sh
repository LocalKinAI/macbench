#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/126-unread-confirm.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 126")
                set read status of m to true
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ inbox messages 'KinBench 126' (if any) pre-marked read; confirm file cleared"
