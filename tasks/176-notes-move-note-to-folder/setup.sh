#!/usr/bin/env bash
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
