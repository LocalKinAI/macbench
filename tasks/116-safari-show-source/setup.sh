#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/116-source.html"
# Make sure Develop menu is enabled
defaults write com.apple.Safari IncludeDevelopMenu -bool true
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://www.example.com"
end tell
APPLE
sleep 3
echo "→ Safari open with Develop menu enabled"
