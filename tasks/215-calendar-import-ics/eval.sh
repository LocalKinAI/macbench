#!/usr/bin/env bash
set -uo pipefail
sleep 2
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set total to 0
    repeat with cal in calendars
        try
            set total to total + (count of (every event of cal whose summary = "KinBench Imported 215"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "matching events: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL: import didn't create event"; exit 1; }
