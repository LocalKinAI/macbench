#!/usr/bin/env bash
set -uo pipefail
sleep 1
COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    set total to 0
    repeat with cal in calendars
        try
            set total to total + (count of (every event of cal whose summary = "KinBench Cancel" ¬
                                  and start date ≥ windowStart and start date ≤ windowEnd))
        end try
    end repeat
    return total
end tell
EOF
)"
echo "remaining matches: $COUNT"
if [[ "$COUNT" == "0" ]]; then
  echo "PASS: event deleted"
  exit 0
fi
echo "FAIL: event still present ($COUNT)"
exit 1
