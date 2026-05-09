#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/182-note.pdf"
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Export 182")
        delete n
    end repeat
    make new note with properties {name:"KinBench Export 182", body:"export body 182"}
end tell
APPLE
