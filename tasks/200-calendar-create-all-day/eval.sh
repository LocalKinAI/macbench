#!/usr/bin/env bash
set -uo pipefail
sleep 1
ALLDAY="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench All-Day 200" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                try
                    return (allday event of ev) as string
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "allday: '$ALLDAY'"
[[ "$ALLDAY" == "true" ]] && { echo "PASS"; exit 0; } || { echo "FAIL: not all-day"; exit 1; }
