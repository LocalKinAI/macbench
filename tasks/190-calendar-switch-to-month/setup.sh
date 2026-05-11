#!/usr/bin/env bash
# 190-calendar-switch-to-month setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/190-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
# Switch to Day view first so agent must actively change it
osascript <<'APPLE' 2>/dev/null || true
tell application "System Events"
    tell process "Calendar"
        try
            keystroke "1" using command down
        end try
    end tell
end tell
APPLE
sleep 0.3
echo "→ Calendar opened in non-Month view, confirm file cleared"
