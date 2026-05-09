#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench All-Day 200")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE
