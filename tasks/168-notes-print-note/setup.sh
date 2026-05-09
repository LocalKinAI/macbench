#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/168-note.pdf"
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Print 168")
        delete n
    end repeat
    make new note with properties {name:"KinBench Print 168", body:"body for 168"}
end tell
APPLE
