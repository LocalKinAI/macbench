#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set total to 0
    repeat with cal in calendars
        try
            set total to total + (count of (every event of cal whose summary = "KinBench Weekly 197"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "occurrences: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
