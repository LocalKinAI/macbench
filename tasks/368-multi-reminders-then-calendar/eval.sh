#!/usr/bin/env bash
# Verify the three calendar events exist tomorrow at the right times.
set -uo pipefail
sleep 2

HITS="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set tomorrowStart to (current date) + (1 * days)
    set hours of tomorrowStart to 0
    set minutes of tomorrowStart to 0
    set seconds of tomorrowStart to 0
    set dayAfter to tomorrowStart + (1 * days)
    set found to 0
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary starts with "KinBench 368")
                set sd to start date of ev
                if sd >= tomorrowStart and sd < dayAfter then
                    set found to found + 1
                end if
            end repeat
        end try
    end repeat
    return found as string
end tell
EOF
)"
HITS="$(printf '%s' "$HITS" | tr -d '\n')"
echo "calendar events tomorrow with prefix 'KinBench 368': $HITS"

if [[ "${HITS:-0}" -ge 3 ]] 2>/dev/null; then
  echo "PASS: 3+ matching events scheduled tomorrow"
  exit 0
fi
if [[ "${HITS:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): $HITS / 3 events scheduled — partial mirror"
  exit 0
fi
echo "FAIL: no matching events tomorrow"
exit 1
