#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Undo 183")
        delete n
    end repeat
    make new note with properties {name:"KinBench Undo 183", body:"kinbench-original-line"}
end tell
APPLE
