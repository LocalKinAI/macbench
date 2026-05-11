#!/usr/bin/env bash
# 212-calendar-merge-duplicate-events setup
# Wipe prior KinBench Dup 212 events, then plant exactly 3
# identical events tomorrow at 09:00.
set -uo pipefail
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Dup 212")
                delete ev
            end repeat
        end try
    end repeat
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 9
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
        make new event with properties {summary:"KinBench Dup 212", start date:tomorrowDate, end date:endDate}
        make new event with properties {summary:"KinBench Dup 212", start date:tomorrowDate, end date:endDate}
        make new event with properties {summary:"KinBench Dup 212", start date:tomorrowDate, end date:endDate}
    end tell
end tell
APPLE
echo "→ planted 3 duplicate KinBench Dup 212 events tomorrow 9:00"
