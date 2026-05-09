#!/usr/bin/env bash
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Alert 198" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                set hasAlarm to (count of (display alarms of ev)) + (count of (sound alarms of ev))
                return hasAlarm as string
            end repeat
        end try
    end repeat
    return "0"
end tell
APPLE
)"
echo "alarm count: $RESULT"
[[ "$RESULT" -ge 1 ]] 2>/dev/null && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
