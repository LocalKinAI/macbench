#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
printf 'kinbench-048 attachable content\n' > "$HOME/Desktop/kinbench/048-attach.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set toDel to (every message of draftBox whose subject = "KinBench 048")
            repeat with m in toDel
                delete m
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ wrote 048-attach.txt + cleared prior drafts"
