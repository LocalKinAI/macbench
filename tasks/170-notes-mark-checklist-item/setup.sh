#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Mark 170")
        delete n
    end repeat
    make new note with properties {name:"KinBench Mark 170", body:"task one
task two
task three"}
end tell
APPLE
