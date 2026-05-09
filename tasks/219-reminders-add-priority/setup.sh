#!/usr/bin/env bash
set -uo pipefail
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Priority 219")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
    tell default list
        make new reminder with properties {name:"KinBench Priority 219", priority:0}
    end tell
end tell
APPLE
echo "→ planted reminder with priority 0"
