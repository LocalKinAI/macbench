#!/usr/bin/env bash
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'EOF' 2>/dev/null
tell application "Safari"
    activate
    delay 0.5
    open location "https://www.apple.com"
end tell
EOF
sleep 1
echo "→ Safari open with apple.com"
