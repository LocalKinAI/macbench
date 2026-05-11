#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/096-zoom-reset.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://www.apple.com"
end tell
delay 2
tell application "System Events"
    tell process "Safari"
        repeat 3 times
            keystroke "=" using {command down}
            delay 0.15
        end repeat
    end tell
end tell
APPLE
sleep 1
echo "→ Safari open and zoomed in 3x"
