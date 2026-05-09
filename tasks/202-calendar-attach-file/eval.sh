#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Attach 202" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                try
                    return (count of attachments of ev) as string
                on error
                    return "0"
                end try
            end repeat
        end try
    end repeat
    return "0"
end tell
APPLE
)"
echo "attachments: $N"
[[ "$N" -ge 1 ]] 2>/dev/null && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
