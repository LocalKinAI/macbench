#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
printf 'kinbench-140 attachable content\n' > "$HOME/Desktop/kinbench/140-attach.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 140")
                delete m
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ wrote 140-attach.txt + cleared prior drafts"
