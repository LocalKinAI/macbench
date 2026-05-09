#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    set defLst to default list
    tell defLst
        make new reminder with properties {name:"KinBench Done A 236", completed:true}
        make new reminder with properties {name:"KinBench Done B 236", completed:true}
        make new reminder with properties {name:"KinBench Done C 236", completed:true}
    end tell
end tell
APPLE
echo "→ planted 3 completed reminders"
