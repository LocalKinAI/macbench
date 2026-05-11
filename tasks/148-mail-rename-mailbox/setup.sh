#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            delete mailbox "kinbench-renamed" of acct
        end try
        try
            set mb to mailbox "kinbench-rename-src" of acct
        on error
            try
                make new mailbox with properties {name:"kinbench-rename-src"} at acct
            end try
        end try
    end repeat
    try
        delete mailbox "kinbench-renamed"
    end try
    try
        set mb to mailbox "kinbench-rename-src"
    on error
        try
            make new mailbox with properties {name:"kinbench-rename-src"}
        end try
    end try
end tell
EOF
echo "→ seeded kinbench-rename-src + cleared prior kinbench-renamed"
