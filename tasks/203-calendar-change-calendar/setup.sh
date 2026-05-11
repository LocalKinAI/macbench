#!/usr/bin/env bash
# 203-calendar-change-calendar setup
# Ensure there are at least 2 writable calendars, then plant
# KinBench Move 203 in the FIRST writable one. Record which
# calendar it started in so eval can check it moved.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/203-origin.txt"

osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    -- Ensure secondary calendar exists
    set hasSecondary to false
    repeat with c in calendars
        if name of c is "KinBench Spare 203" then set hasSecondary to true
    end repeat
    if not hasSecondary then
        try
            make new calendar with properties {name:"KinBench Spare 203"}
        end try
    end if
    -- Clean prior
    repeat with c in calendars
        try
            repeat with ev in (every event of c whose summary = "KinBench Move 203")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE

# Plant fresh and record origin
ORIGIN=$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 13
    set minutes of tomorrowDate to 0
    set seconds of tomorrowDate to 0
    set endDate to tomorrowDate + (30 * minutes)
    -- pick first writable calendar that is not the spare we just made
    set targetCal to missing value
    repeat with c in calendars
        if (writable of c) is true and (name of c) is not "KinBench Spare 203" then
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
        make new event with properties {summary:"KinBench Move 203", start date:tomorrowDate, end date:endDate}
    end tell
    return (name of targetCal)
end tell
APPLE
)
printf '%s' "$ORIGIN" > "$SANDBOX/203-origin.txt"
echo "→ planted KinBench Move 203 in calendar '$ORIGIN'"
