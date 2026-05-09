#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose completed is true))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "remaining completed reminders globally: $N"
[[ "$N" == "0" ]] && { echo "PASS"; exit 0; }
echo "FAIL: $N completed reminders still present"
exit 1
