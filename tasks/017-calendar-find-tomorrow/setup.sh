#!/usr/bin/env bash
# Plant a "KinBench Find Me" event tomorrow at 14:30 in the user's
# default calendar. Eval will read the file the agent writes back.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/017-found-time.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    -- delete any prior occurrence
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Find Me")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
    -- create tomorrow at 14:30 - 15:00 in the default-ish calendar
    set tomorrowDate to (current date) + (1 * days)
    set hours of tomorrowDate to 14
    set minutes of tomorrowDate to 30
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
        make new event with properties {summary:"KinBench Find Me", start date:tomorrowDate, end date:endDate}
    end tell
end tell
EOF
echo "→ planted KinBench Find Me event tomorrow at 14:30"
