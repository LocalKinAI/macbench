#!/usr/bin/env bash
# 191-calendar-switch-to-week setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/191-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
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
echo "→ Calendar opened in non-Week view"
