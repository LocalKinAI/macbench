#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/361-photo.jpg"
osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 361")
                delete m
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ photo + drafts cleared"
