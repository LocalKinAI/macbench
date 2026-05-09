#!/usr/bin/env bash
osascript -e 'tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary contains "Lunch with Bob")
                delete ev
            end repeat
        end try
    end repeat
end tell' 2>/dev/null || true
