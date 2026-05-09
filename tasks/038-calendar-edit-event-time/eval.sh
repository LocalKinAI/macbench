#!/usr/bin/env bash
# Pass: event start hour == 11 (was 10).
set -uo pipefail
sleep 1

WHEN="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Reschedule" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                return ((start date of ev) as string)
            end repeat
        end try
    end repeat
    return ""
end tell
EOF
)"

echo "event start: $WHEN"
if [[ -z "$WHEN" ]]; then
  echo "FAIL: event missing"
  exit 1
fi
if [[ "$WHEN" == *"11:00"* ]]; then
  echo "PASS: rescheduled to 11:00"
  exit 0
fi
echo "FAIL: event time not 11:00"
exit 2
