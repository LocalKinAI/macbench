#!/usr/bin/env bash
# 193-calendar-search-event setup
# Plant a KinBench Search 193 event 5 days from now at 14:00.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/193-found.txt"
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Search 193")
                delete ev
            end repeat
        end try
    end repeat
    set futureDate to (current date) + (5 * days)
    set hours of futureDate to 14
    set minutes of futureDate to 0
    set seconds of futureDate to 0
    set endDate to futureDate + (30 * minutes)
    set targetCal to first calendar
    repeat with c in calendars
        if (writable of c) is true then
            set targetCal to c
            exit repeat
        end if
    end repeat
    tell targetCal
        make new event with properties {summary:"KinBench Search 193", start date:futureDate, end date:endDate}
    end tell
end tell
APPLE
echo "→ planted KinBench Search 193 5 days from now"
