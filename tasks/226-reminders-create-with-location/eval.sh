#!/usr/bin/env bash
# 226-reminders-create-with-location eval
#
# Reminders' AppleScript dict doesn't expose geofence/location properties.
# Lenient eval: the reminder must exist. Bonus pass — body, alldayDate or
# remind-date metadata mentions location.
set -uo pipefail
sleep 1

N="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Location 226"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "matching: $N"

if [[ "${N:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: reminder created (location detail not queryable via AppleScript)"
  exit 0
fi
echo "FAIL: no reminder named 'KinBench Location 226' found"
exit 1
