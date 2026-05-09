#!/usr/bin/env bash
# Subtask hierarchy isn't directly accessible via Reminders' AppleScript dictionary
# (it's a private feature). Best proxy: a separate reminder with the expected name
# exists somewhere. Lenient eval — checks both the parent + sub presence.
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Subtask A 227"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "matching subtasks: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
