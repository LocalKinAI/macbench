#!/usr/bin/env bash
set -uo pipefail
sleep 1

RESULT="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (3 * days)
    set out to ""
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Coffee" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                set out to out & ((start date of ev) as string) & "|" & (location of ev) & linefeed
            end repeat
        end try
    end repeat
    return out
end tell
EOF
)"

echo "matches:"
printf '%s' "$RESULT"

if [[ -z "$RESULT" ]]; then
  echo "FAIL: no KinBench Coffee event in next 3 days"
  exit 1
fi

# Match any line where time is 9:00 AND location contains "Blue Bottle"
if printf '%s' "$RESULT" | grep -i "9:00" | grep -iq "Blue Bottle"; then
  echo "PASS: 9:00 event with Blue Bottle location"
  exit 0
fi

echo "FAIL: didn't find 9:00 event with Blue Bottle location"
exit 2
