#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with f in (every folder whose name = "kinbench-folder")
        delete f
    end repeat
end tell
APPLE
