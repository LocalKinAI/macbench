#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat
        try
            delete (first list whose name = "kinbench-rename-pre")
        on error
            exit repeat
        end try
    end repeat
    repeat
        try
            delete (first list whose name = "kinbench-rename-post")
        on error
            exit repeat
        end try
    end repeat
    make new list with properties {name:"kinbench-rename-pre"}
end tell
APPLE
