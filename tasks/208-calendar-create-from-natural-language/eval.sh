#!/usr/bin/env bash
set -uo pipefail
sleep 1
WHEN="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary contains "Lunch with Bob" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                return ((start date of ev) as string)
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "event start: '$WHEN'"
if [[ -z "$WHEN" ]]; then echo "FAIL: no event found"; exit 1; fi
if [[ "$WHEN" == *"12:00"* ]]; then
  echo "PASS: lunch event at noon"; exit 0
fi
echo "FAIL: event found but not at noon"
exit 2
