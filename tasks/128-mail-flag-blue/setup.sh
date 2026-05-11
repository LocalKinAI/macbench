#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/128-flag-confirm.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 128")
                try
                    set flag index of m to -1
                end try
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ 'KinBench 128' flags cleared; confirm file cleared"
