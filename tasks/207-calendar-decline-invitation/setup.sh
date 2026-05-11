#!/usr/bin/env bash
# 207-calendar-decline-invitation setup
set -uo pipefail
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Invite 207")
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
    repeat with c in calendars
        if (writable of c) is true then
            set targetCal to c
            exit repeat
        end if
    end repeat
    tell targetCal
        make new event with properties {summary:"KinBench Invite 207", start date:tomorrowDate, end date:endDate, description:"PENDING"}
    end tell
end tell
APPLE
echo "→ planted KinBench Invite 207 with description=PENDING"
