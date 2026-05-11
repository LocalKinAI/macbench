#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/127-flag-confirm.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set inb to mailbox "INBOX" of acct
            repeat with m in (every message of inb whose subject = "KinBench 127")
                try
                    set flag index of m to -1
                end try
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ flags cleared on 'KinBench 127' messages (if any); confirm file cleared"
