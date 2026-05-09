#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    set theNotes to every note whose name = "KinBench Test 014"
    repeat with n in theNotes
        delete n
    end repeat
end tell
EOF
echo "→ cleared prior KinBench Test 014 notes"
