#!/usr/bin/env bash
# 228-reminders-mark-subtask setup
#
# AppleScript can't nest subtasks directly. We plant a parent + a sibling
# named like a subtask. Eval is lenient — checks subtask completion only.
set -uo pipefail

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Parent 228")
                delete r
            end repeat
            repeat with r in (every reminder of lst whose name = "KinBench Subtask 228")
                delete r
            end repeat
        end try
    end repeat
    tell default list
        make new reminder with properties {name:"KinBench Parent 228"}
        make new reminder with properties {name:"KinBench Subtask 228", completed:false}
    end tell
end tell
APPLE
echo "→ planted parent + subtask (uncompleted)"
