#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench URL 201")
                delete ev
            end repeat
        end try
    end repeat
    set tmrw to (current date) + (1 * days)
    set hours of tmrw to 9
    set minutes of tmrw to 0
    set seconds of tmrw to 0
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
        make new event with properties {summary:"KinBench URL 201", start date:tmrw, end date:tmrw + (30 * minutes)}
    end tell
end tell
APPLE
echo "→ planted KinBench URL 201 event without URL"
