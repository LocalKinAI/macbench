#!/usr/bin/env bash
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.5
    open location "https://www.apple.com"
    delay 0.5
    tell front window
        set current tab to (make new tab with properties {URL:"https://github.com"})
        delay 0.5
        set current tab to (make new tab with properties {URL:"https://en.wikipedia.org"})
    end tell
end tell
APPLE
sleep 1
echo "→ 3 tabs open (apple, github, wikipedia)"
