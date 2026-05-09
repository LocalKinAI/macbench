#!/usr/bin/env bash
# Plant an uncompleted reminder named "KinBench Mark Done".
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Mark Done")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
    set defLst to default list
    tell defLst
        make new reminder with properties {name:"KinBench Mark Done", completed:false}
    end tell
end tell
EOF
echo "→ planted uncompleted 'KinBench Mark Done'"
