#!/usr/bin/env bash
# 222-reminders-show-today setup
#
# Plants a reminder due today so the Today smart list isn't empty, and
# clears the agent-side confirmation file.
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/222-today-confirm.txt"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Today 222")
                delete r
            end repeat
        end try
    end repeat
    set d to current date
    set hours of d to 18
    set minutes of d to 0
    set seconds of d to 0
    tell default list
        make new reminder with properties {name:"KinBench Today 222", due date:d}
    end tell
end tell
APPLE
echo "→ planted reminder due today 'KinBench Today 222'"
