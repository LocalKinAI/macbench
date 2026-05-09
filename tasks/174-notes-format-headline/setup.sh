#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Heading 174")
        delete n
    end repeat
    make new note with properties {name:"KinBench Heading 174", body:"first line is heading
second line is body"}
end tell
APPLE
