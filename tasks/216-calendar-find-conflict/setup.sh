#!/usr/bin/env bash
# 216-calendar-find-conflict setup
# Plant overlapping events tomorrow:
#   KinBench Conf A: 10:00-11:00
#   KinBench Conf B: 10:30-11:30  (overlaps A)
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/216-conflicts.txt"

osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary starts with "KinBench Conf")
                delete ev
            end repeat
        end try
    end repeat
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 10
    set minutes of tomorrowDate to 0
    set seconds of tomorrowDate to 0
    set aStart to tomorrowDate
    set aEnd to aStart + (1 * hours)
    set bStart to tomorrowDate
    set minutes of bStart to 30
    set bEnd to bStart + (1 * hours)
    set targetCal to first calendar
    repeat with c in calendars
        if (writable of c) is true then
            set targetCal to c
            exit repeat
        end if
    end repeat
    tell targetCal
        make new event with properties {summary:"KinBench Conf A", start date:aStart, end date:aEnd}
        make new event with properties {summary:"KinBench Conf B", start date:bStart, end date:bEnd}
    end tell
end tell
APPLE
echo "→ planted KinBench Conf A (10:00-11:00) and B (10:30-11:30)"
