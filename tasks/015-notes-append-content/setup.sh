#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    -- wipe + recreate
    set theNotes to every note whose name = "KinBench Test 015"
    repeat with n in theNotes
        delete n
    end repeat
    make new note with properties {name:"KinBench Test 015", body:"original line"}
end tell
EOF
echo "→ recreated 'KinBench Test 015' with body 'original line'"
