#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-export-238")
    end try
    set L to make new list with properties {name:"kinbench-export-238"}
    tell L
        make new reminder with properties {name:"Item Alpha"}
        make new reminder with properties {name:"Item Beta"}
        make new reminder with properties {name:"Item Gamma"}
    end tell
end tell
APPLE
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/238-list.txt"
echo "→ list 'kinbench-export-238' has 3 reminders"
