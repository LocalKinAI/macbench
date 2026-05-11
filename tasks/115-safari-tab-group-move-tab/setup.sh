#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/115-tabgroup-move-confirm.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://en.wikipedia.org"
end tell
delay 2
# Try to create the 'KinBench Research' tab group via menu (best-effort)
tell application "System Events"
    tell process "Safari"
        try
            click menu item "New Empty Tab Group" of menu "File" of menu bar 1
            delay 0.6
            keystroke "KinBench Research"
            delay 0.2
            keystroke return
            delay 0.4
        end try
    end tell
end tell
APPLE
sleep 1
echo "→ Safari open on wikipedia + best-effort tab group create"
