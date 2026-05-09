#!/usr/bin/env bash
# Pass: ≥1 KinBench Lunch event scheduled in the next ~36 hours
# (window covers "tomorrow at 12:30" regardless of when the test
# runs in the day).
set -uo pipefail
sleep 1

RESULT="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set startWindow to (current date)
    set endWindow to (current date) + (36 * hours)
    set total to 0
    set foundHr to ""
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Lunch" ¬
                       and start date ≥ startWindow and start date ≤ endWindow)
            repeat with ev in evs
                set total to total + 1
                set foundHr to (start date of ev) as string
            end repeat
        end try
    end repeat
    return (total as string) & "|" & foundHr
end tell
EOF
)"

COUNT="${RESULT%%|*}"
WHEN="${RESULT#*|}"
echo "matching events: $COUNT  start: $WHEN"

if [[ "$COUNT" -ge 1 ]]; then
  # Soft check that 12:30 appears in the date string (date format
  # varies by locale but "12:30" is robust).
  if [[ "$WHEN" == *"12:30"* ]]; then
    echo "PASS: KinBench Lunch event scheduled at 12:30"
    exit 0
  fi
  echo "WARN: event found but time != 12:30 — counting as fail"
  exit 2
fi
echo "FAIL: no KinBench Lunch event in next 36h"
exit 1
