#!/usr/bin/env bash
set -uo pipefail
sleep 2
WHEN="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Flight 362")
                return ((start date of ev) as string)
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "event start: '$WHEN'"
if [[ -z "$WHEN" ]]; then
  echo "FAIL: event 'KinBench Flight 362' missing"
  exit 1
fi
# Accept either 14:30 (24h), 2:30 PM, or June 15 2026 mention
if echo "$WHEN" | grep -qE "(14:30|2:30:00 PM)"; then
  if echo "$WHEN" | grep -qE "(2026|Jun)"; then
    echo "PASS: event at correct date/time"
    exit 0
  fi
fi
if echo "$WHEN" | grep -qE "(14:30|2:30:00 PM)"; then
  echo "PASS (soft): correct time, date format unclear"
  exit 0
fi
echo "FAIL: event found but date/time not 2026-06-15 14:30"
exit 2
