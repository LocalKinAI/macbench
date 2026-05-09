#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Table 172")
        delete n
    end repeat
    make new note with properties {name:"KinBench Table 172", body:"placeholder for table"}
end tell
APPLE
