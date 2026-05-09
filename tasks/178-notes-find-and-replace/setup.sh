#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Replace 178")
        delete n
    end repeat
    make new note with properties {name:"KinBench Replace 178", body:"This is version 1 of the document."}
end tell
APPLE
echo "→ note has 'version 1' in body"
