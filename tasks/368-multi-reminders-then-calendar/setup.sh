#!/usr/bin/env bash
set -uo pipefail
TODAY="$(date +'%Y-%m-%d')"

# Plant reminders for today
osascript <<APPLE 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "KinBench 368")
    end try
    make new list with properties {name:"KinBench 368"}
    tell list "KinBench 368"
        set d1 to current date
        set year of d1 to ${TODAY:0:4}
        set month of d1 to ${TODAY:5:2}
        set day of d1 to ${TODAY:8:2}
        set hours of d1 to 9
        set minutes of d1 to 0
        set seconds of d1 to 0
        make new reminder with properties {name:"KinBench 368 morning", due date:d1}

        set d2 to current date
        set year of d2 to ${TODAY:0:4}
        set month of d2 to ${TODAY:5:2}
        set day of d2 to ${TODAY:8:2}
        set hours of d2 to 12
        set minutes of d2 to 0
        set seconds of d2 to 0
        make new reminder with properties {name:"KinBench 368 noon", due date:d2}

        set d3 to current date
        set year of d3 to ${TODAY:0:4}
        set month of d3 to ${TODAY:5:2}
        set day of d3 to ${TODAY:8:2}
        set hours of d3 to 17
        set minutes of d3 to 0
        set seconds of d3 to 0
        make new reminder with properties {name:"KinBench 368 evening", due date:d3}
    end tell
end tell
APPLE

# Clear prior calendar events
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary starts with "KinBench 368")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ planted 3 reminders for $TODAY + cleared calendar events"
