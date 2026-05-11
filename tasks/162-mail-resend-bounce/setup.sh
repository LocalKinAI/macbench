#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"

# Clear anything matching either original or expected new subject
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 162 Resend")
                delete m
            end repeat
            repeat with m in (every message of draftBox whose subject contains "Re-sending")
                delete m
            end repeat
        end try
    end repeat
end tell
EOF

# Seed the original draft
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    set m to make new outgoing message with properties {subject:"KinBench 162 Resend", content:"Bounced. Try again."}
    save m
    try
        tell window 1 to close saving yes
    end try
end tell
EOF
sleep 1
echo "→ seeded 'KinBench 162 Resend' draft"
