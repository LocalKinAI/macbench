#!/usr/bin/env bash
# Clear any prior drafts with our subject so eval is unambiguous.
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set toDel to (every message of draftBox whose subject = "KinBench 016 Test")
            repeat with m in toDel
                delete m
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ cleared prior KinBench 016 drafts"
