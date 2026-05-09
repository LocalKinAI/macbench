#!/usr/bin/env bash
# Pre-open three tabs so the agent's job is just to close one.
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1

osascript <<'EOF' 2>/dev/null
tell application "Safari"
    activate
    delay 0.5
    open location "https://www.apple.com"
    delay 0.6
    tell front window
        set current tab to (make new tab with properties {URL:"https://github.com"})
        delay 0.6
        set current tab to (make new tab with properties {URL:"https://en.wikipedia.org"})
    end tell
end tell
EOF

sleep 1
echo "→ pre-opened 3 tabs in Safari"
