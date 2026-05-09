#!/usr/bin/env bash
set -uo pipefail
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Flag 220")
                delete r
            end repeat
        end try
    end repeat
    tell default list
        make new reminder with properties {name:"KinBench Flag 220"}
    end tell
end tell
APPLE
