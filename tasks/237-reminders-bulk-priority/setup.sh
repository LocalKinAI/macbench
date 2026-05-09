#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name starts with "KinBench Today 237")
                delete r
            end repeat
        end try
    end repeat
    set today to (current date)
    set hours of today to 17
    set minutes of today to 0
    set seconds of today to 0
    tell default list
        make new reminder with properties {name:"KinBench Today 237 A", priority:0, due date:today}
        make new reminder with properties {name:"KinBench Today 237 B", priority:0, due date:today}
        make new reminder with properties {name:"KinBench Today 237 C", priority:0, due date:today}
    end tell
end tell
APPLE
echo "→ planted 3 reminders due today, priority 0"
