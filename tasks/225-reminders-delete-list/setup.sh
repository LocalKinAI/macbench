#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-deleteme-225")
    end try
    make new list with properties {name:"kinbench-deleteme-225"}
end tell
APPLE
