#!/usr/bin/env bash
# Force Finder to a known starting folder so we can detect navigation.
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Finder"
    activate
    if (count of windows) = 0 then
        make new Finder window
    end if
    set target of front window to (path to home folder)
end tell
EOF
sleep 1
echo "→ Finder front window pointed at home"
