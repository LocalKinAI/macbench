#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-rename-pre")
    end try
    try
        delete (first list whose name = "kinbench-rename-post")
    end try
end tell
APPLE
