#!/usr/bin/env bash
# Pass: event exists tomorrow at 15:00. (We don't try to verify
# Spotlight was used — that path doesn't leave a queryable trail.
# This task essentially tests "did Calendar get used" + correct
# output. The Spotlight phrasing is a usability cue, not a hard
# constraint — agents that direct-launch Calendar still pass.)
set -uo pipefail
sleep 1

WHEN="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Spotlight Path" ¬
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
if [[ "$WHEN" == *"3:00:00 PM"* ]] || [[ "$WHEN" == *"15:00"* ]]; then
  echo "PASS: event scheduled at 3 PM"
  exit 0
fi
echo "FAIL: event found but time not 3 PM"
exit 2
