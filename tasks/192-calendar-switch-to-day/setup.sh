#!/usr/bin/env bash
# 192-calendar-switch-to-day setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/192-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
# Switch to Month view first so agent has to actively switch to Day
osascript <<'APPLE' 2>/dev/null || true
tell application "System Events"
    tell process "Calendar"
        try
            keystroke "3" using command down
        end try
    end tell
end tell
APPLE
sleep 0.3
echo "→ Calendar opened in non-Day view"
