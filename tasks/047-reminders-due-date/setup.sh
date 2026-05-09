#!/usr/bin/env bash
# Plant reminder with no due date.
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Schedule")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
    set defLst to default list
    tell defLst
        make new reminder with properties {name:"KinBench Schedule"}
    end tell
end tell
EOF
echo "→ planted KinBench Schedule (no due date)"
