#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/146-move-confirm.txt"
# Clear any previous KinBench 146 mailbox so a fresh create is testable
osascript <<'EOF' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            delete mailbox "KinBench 146" of acct
        end try
    end repeat
end tell
EOF
echo "→ prior 'KinBench 146' mailbox + confirm file cleared"
