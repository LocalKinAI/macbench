#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/163-promo-count.txt"
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            delete mailbox "kinbench-promos" of acct
        end try
    end repeat
    try
        delete mailbox "kinbench-promos"
    end try
end tell
EOF
echo "→ count file + kinbench-promos mailbox cleared"
