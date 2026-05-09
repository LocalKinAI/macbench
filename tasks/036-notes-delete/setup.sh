#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    -- Idempotent: nuke prior + recreate fresh.
    set theNotes to every note whose name = "KinBench Test 036 (delete me)"
    repeat with n in theNotes
        delete n
    end repeat
    make new note with properties {name:"KinBench Test 036 (delete me)", body:"will be deleted"}
end tell
EOF
echo "→ planted note for deletion"
