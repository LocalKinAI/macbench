#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Lock 166")
        delete n
    end repeat
    make new note with properties {name:"KinBench Lock 166", body:"KINBENCH-LOCK-MARKER-166 — readable when unlocked"}
end tell
APPLE
