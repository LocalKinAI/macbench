#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Pinned 164")
        delete n
    end repeat
    make new note with properties {name:"KinBench Pinned 164", body:"placeholder"}
end tell
APPLE
