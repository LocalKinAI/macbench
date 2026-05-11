#!/usr/bin/env bash
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
# Seed apple.com into Safari history by visiting it first, then navigate away.
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://www.apple.com"
end tell
APPLE
sleep 3
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    set URL of front document to "https://www.example.com"
end tell
APPLE
sleep 3
echo "→ apple.com is in history; Safari now on example.com"
