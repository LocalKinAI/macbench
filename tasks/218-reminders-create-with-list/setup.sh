#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-list-218")
    end try
    make new list with properties {name:"kinbench-list-218"}
end tell
APPLE
