#!/usr/bin/env bash
# 212-calendar-merge-duplicate-events eval
# Pass: exactly 1 'KinBench Dup 212' remains across all calendars.
set -uo pipefail
sleep 1
COUNT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set total to 0
    repeat with cal in calendars
        try
            set total to total + (count of (every event of cal whose summary = "KinBench Dup 212"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "remaining duplicates: $COUNT"
if [[ "$COUNT" == "1" ]]; then
  echo "PASS: exactly 1 event remains"
  exit 0
fi
if [[ "$COUNT" -gt 1 ]] 2>/dev/null; then
  echo "FAIL: $COUNT events still present (didn't dedupe)"
  exit 2
fi
echo "FAIL: all events deleted (overshot)"
exit 3
