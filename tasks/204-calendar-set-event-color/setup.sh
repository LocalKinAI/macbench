#!/usr/bin/env bash
# 204-calendar-set-event-color setup
# Plant KinBench Color 204 in a calendar; eval pass = moved to a
# different calendar.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/204-origin.txt"

osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    set hasSecondary to false
    repeat with c in calendars
        if name of c is "KinBench Spare 204" then set hasSecondary to true
    end repeat
    if not hasSecondary then
        try
            make new calendar with properties {name:"KinBench Spare 204"}
        end try
    end if
    repeat with c in calendars
        try
            repeat with ev in (every event of c whose summary = "KinBench Color 204")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE

ORIGIN=$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 15
    set minutes of tomorrowDate to 0
    set seconds of tomorrowDate to 0
    set endDate to tomorrowDate + (30 * minutes)
    set targetCal to missing value
    repeat with c in calendars
        if (writable of c) is true and (name of c) is not "KinBench Spare 204" then
            set targetCal to c
            exit repeat
        end if
    end repeat
    if targetCal is missing value then
        repeat with c in calendars
            if (writable of c) is true then
                set targetCal to c
                exit repeat
            end if
        end repeat
    end if
    tell targetCal
        make new event with properties {summary:"KinBench Color 204", start date:tomorrowDate, end date:endDate}
    end tell
    return (name of targetCal)
end tell
APPLE
)
printf '%s' "$ORIGIN" > "$SANDBOX/204-origin.txt"
echo "→ planted KinBench Color 204 in calendar '$ORIGIN'"
