#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/147-create-confirm.txt"
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            delete mailbox "kinbench-test-mailbox" of acct
        end try
    end repeat
    try
        delete mailbox "kinbench-test-mailbox"
    end try
end tell
EOF
echo "→ prior kinbench-test-mailbox cleared"
