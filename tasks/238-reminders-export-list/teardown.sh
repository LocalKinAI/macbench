#!/usr/bin/env bash
osascript -e 'tell application "Reminders"
    try
        delete (first list whose name = "kinbench-export-238")
    end try
end tell' 2>/dev/null || true
