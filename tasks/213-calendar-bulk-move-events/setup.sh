#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    -- ensure 'KinBench Calendar' exists
    set found to false
    repeat with c in calendars
        if name of c = "KinBench Calendar" then
            set found to true
            exit repeat
        end if
    end repeat
    if not found then
        make new calendar with properties {name:"KinBench Calendar"}
    end if
    -- plant 3 'KinBench Bulk' events in a different calendar
    set src to first calendar
    repeat with c in calendars
        if (writable of c) is true and (name of c) ≠ "KinBench Calendar" then
            set src to c
            exit repeat
        end if
    end repeat
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Bulk")
                delete ev
            end repeat
        end try
    end repeat
    set base to (current date)
    set hours of base to 10
    tell src
        repeat with i from 1 to 3
            make new event with properties {summary:"KinBench Bulk", start date:base + (i * days), end date:base + (i * days) + (30 * minutes)}
        end repeat
    end tell
end tell
APPLE
echo "→ planted 3 KinBench Bulk events outside KinBench Calendar"
