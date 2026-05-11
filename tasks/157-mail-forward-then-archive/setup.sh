#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/157-archive-confirm.txt"
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 157")
                delete m
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ prior 'KinBench 157' drafts + archive confirm cleared"
