#!/usr/bin/env bash
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set inTarget to 0
    set outsideTarget to 0
    repeat with cal in calendars
        try
            set n to count of (every event of cal whose summary = "KinBench Bulk")
            if name of cal = "KinBench Calendar" then
                set inTarget to inTarget + n
            else
                set outsideTarget to outsideTarget + n
            end if
        end try
    end repeat
    return (inTarget as string) & "|" & (outsideTarget as string)
end tell
APPLE
)"
IN="${RESULT%%|*}"
OUT="${RESULT#*|}"
echo "in target: $IN, outside: $OUT"
if [[ "$IN" -ge 3 && "$OUT" == "0" ]]; then echo "PASS"; exit 0; fi
echo "FAIL: expected (≥3, 0)"
exit 1
