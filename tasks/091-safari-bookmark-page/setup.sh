#!/usr/bin/env bash
# 091 setup: open Safari to apple.com so the agent has a real page to bookmark.
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/091-bookmark-confirm.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://www.apple.com"
end tell
APPLE
sleep 2
echo "→ Safari open on apple.com; confirm file pre-cleared"
