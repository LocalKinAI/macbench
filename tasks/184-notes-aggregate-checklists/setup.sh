#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with title in {"KinBench Source 184 alpha", "KinBench Source 184 bravo", "KinBench Source 184 charlie", "KinBench Aggregate 184"}
        repeat with n in (every note whose name = title)
            delete n
        end repeat
    end repeat
    make new note with properties {name:"KinBench Source 184 alpha", body:"alpha header
✓ alpha-done-one
○ alpha-pending-one
✓ alpha-done-two"}
    make new note with properties {name:"KinBench Source 184 bravo", body:"bravo header
○ bravo-pending-one
✓ bravo-done-only"}
    make new note with properties {name:"KinBench Source 184 charlie", body:"charlie header
○ charlie-pending-one
○ charlie-pending-two"}
end tell
APPLE
echo "→ 3 source notes seeded; expected aggregate items: alpha-done-one, alpha-done-two, bravo-done-only"
