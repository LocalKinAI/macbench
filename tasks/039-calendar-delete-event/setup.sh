#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Cancel")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 16
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
        make new event with properties {summary:"KinBench Cancel", start date:tomorrowDate, end date:endDate}
    end tell
end tell
EOF
echo "→ planted KinBench Cancel tomorrow at 16:00"
