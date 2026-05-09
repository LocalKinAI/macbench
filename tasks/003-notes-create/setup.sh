#!/usr/bin/env bash
# 003-notes-create setup
#
# Removes any prior "KinBench Test 003" note from previous runs so
# the eval cleanly verifies *this* run created it.

set -uo pipefail

osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    set theNotes to every note whose name = "KinBench Test 003"
    repeat with n in theNotes
        delete n
    end repeat
end tell
EOF

echo "→ cleared prior KinBench Test 003 notes (if any)"
