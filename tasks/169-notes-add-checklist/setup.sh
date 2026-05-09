#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Checklist 169")
        delete n
    end repeat
    make new note with properties {name:"KinBench Checklist 169", body:"existing content"}
end tell
APPLE
