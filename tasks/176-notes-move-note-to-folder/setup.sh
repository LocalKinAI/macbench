#!/usr/bin/env bash
# Activate Notes first so the agent finds it ready (PID-snapshot isolation may
# kill the previous Notes process; first AppleScript call after that has cold-
# start latency that can race with the agent's first probe).
osascript -e 'tell application "Notes" to activate' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Move 176")
        delete n
    end repeat
    repeat with f in (every folder whose name = "kinbench-folder")
        try
            delete f
        end try
    end repeat
    make new folder with properties {name:"kinbench-folder"}
    make new note with properties {name:"KinBench Move 176", body:"to be moved"}
end tell
APPLE
sleep 1
echo "→ folder kinbench-folder + note 'KinBench Move 176' planted"
