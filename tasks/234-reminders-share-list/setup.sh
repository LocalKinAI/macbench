#!/usr/bin/env bash
# 234-reminders-share-list setup
#
# Ensures the list 'kinbench-share-234' exists, clears agent-side confirmation.
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/234-share-confirm.txt"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-share-234")
    end try
    make new list with properties {name:"kinbench-share-234"}
end tell
APPLE
echo "→ planted list 'kinbench-share-234'"
