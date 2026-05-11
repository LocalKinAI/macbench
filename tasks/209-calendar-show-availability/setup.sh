#!/usr/bin/env bash
# 209-calendar-show-availability setup
# Plant 2 events tomorrow:
#   10:00-11:00 KinBench Busy 209A
#   14:00-15:00 KinBench Busy 209B
# Then 9-10, 11-12, 12-13, 13-14, 15-16, 16-17 are all free 1h slots.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/209-slots.txt"

osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    -- Wipe prior planted busy events AND any other KinBench- prefixed
    -- events tomorrow (to avoid contamination from other tasks).
    set tomorrowStart to (current date) + (1 * days)
    set hours of tomorrowStart to 0
    set minutes of tomorrowStart to 0
    set seconds of tomorrowStart to 0
    set tomorrowEnd to tomorrowStart + (1 * days)
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary starts with "KinBench" ¬
                              and start date ≥ tomorrowStart and start date < tomorrowEnd)
                delete ev
            end repeat
        end try
    end repeat
    -- Now plant 10:00 and 14:00 busy events
    set targetCal to first calendar
    repeat with c in calendars
        if (writable of c) is true then
            set targetCal to c
            exit repeat
        end if
    end repeat
    set b1 to tomorrowStart
    set hours of b1 to 10
    set b1e to b1 + (1 * hours)
    set b2 to tomorrowStart
    set hours of b2 to 14
    set b2e to b2 + (1 * hours)
    tell targetCal
        make new event with properties {summary:"KinBench Busy 209A", start date:b1, end date:b1e}
        make new event with properties {summary:"KinBench Busy 209B", start date:b2, end date:b2e}
    end tell
end tell
APPLE
echo "→ planted KinBench Busy 209 events tomorrow 10-11 and 14-15"
