#!/usr/bin/env bash
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.5
    open location "https://github.com"
    delay 1.0
    tell front window
        set current tab to (make new tab with properties {URL:"https://en.wikipedia.org"})
        delay 1.0
        set current tab to (make new tab with properties {URL:"https://www.apple.com"})
    end tell
end tell
APPLE
sleep 2
echo "→ tabs seeded in order: github, wikipedia, apple"
