#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Merge A 185")
        delete n
    end repeat
    repeat with n in (every note whose name = "KinBench Merge B 185")
        delete n
    end repeat
    repeat with n in (every note whose name = "KinBench Merged 185")
        delete n
    end repeat
    make new note with properties {name:"KinBench Merge A 185", body:"alpha-marker-185 first half"}
    make new note with properties {name:"KinBench Merge B 185", body:"bravo-marker-185 second half"}
end tell
APPLE
