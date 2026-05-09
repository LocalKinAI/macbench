#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Tag 180")
        delete n
    end repeat
    make new note with properties {name:"KinBench Tag 180", body:"placeholder content"}
end tell
APPLE
