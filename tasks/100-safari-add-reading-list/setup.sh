#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/100-reading-list-confirm.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://en.wikipedia.org/wiki/macOS"
end tell
APPLE
sleep 3
echo "→ Safari open on wikipedia macOS page"
