#!/usr/bin/env bash
set -uo pipefail

# (1) Plant the source event.
osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Source Event")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 11
    set minutes of tomorrowDate to 0
    set seconds of tomorrowDate to 0
    set endDate to tomorrowDate + (30 * minutes)
    set targetCal to first calendar
    try
        repeat with c in calendars
            if (writable of c) is true then
                set targetCal to c
                exit repeat
            end if
        end repeat
    end try
    tell targetCal
        make new event with properties {summary:"KinBench Source Event", start date:tomorrowDate, end date:endDate}
    end tell
end tell
EOF

# (2) Wipe any prior matching reminders.
osascript <<'EOF' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Source Event")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
end tell
EOF

echo "→ planted Calendar event + cleared prior reminders"
