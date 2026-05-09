#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Bold 173")
        delete n
    end repeat
    make new note with properties {name:"KinBench Bold 173", body:"surrounding text this is bold and more text"}
end tell
APPLE
