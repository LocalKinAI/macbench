#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/029-shot.png"

# Wipe prior matching drafts.
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set toDel to (every message of draftBox whose subject = "KinBench 029 Screenshot")
            repeat with m in toDel
                delete m
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ cleared 029-shot.png + prior matching drafts"
