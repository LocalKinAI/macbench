#!/usr/bin/env bash
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set highCnt to 0
    set total to 0
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name starts with "KinBench Today 237")
            repeat with r in rs
                set total to total + 1
                if priority of r = 1 then set highCnt to highCnt + 1
            end repeat
        end try
    end repeat
    return (highCnt as string) & "/" & (total as string)
end tell
APPLE
)"
echo "high priority / total: $RESULT"
HIGH="${RESULT%%/*}"
TOTAL="${RESULT#*/}"
if [[ "$HIGH" == "$TOTAL" && "$HIGH" -ge 3 ]]; then echo "PASS"; exit 0; fi
echo "FAIL"
exit 1
