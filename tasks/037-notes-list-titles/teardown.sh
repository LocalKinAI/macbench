#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    set toDel to (every note whose name starts with "KinBench Listing")
    repeat with n in toDel
        delete n
    end repeat
end tell
EOF
