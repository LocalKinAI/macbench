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
end tell
APPLE
