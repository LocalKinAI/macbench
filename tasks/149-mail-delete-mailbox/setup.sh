#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set mb to mailbox "kinbench-deleteme" of acct
        on error
            try
                make new mailbox with properties {name:"kinbench-deleteme"} at acct
            end try
        end try
    end repeat
    try
        set mb to mailbox "kinbench-deleteme"
    on error
        try
            make new mailbox with properties {name:"kinbench-deleteme"}
        end try
    end try
end tell
EOF
echo "→ seeded kinbench-deleteme mailbox"
