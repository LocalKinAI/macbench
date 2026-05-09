#!/usr/bin/env bash
set -uo pipefail
sleep 1
NOTES="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Note 205")
                try
                    return description of ev
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "notes: '$NOTES'"
if printf '%s' "$NOTES" | grep -q "KinBench note for event 205"; then
  echo "PASS"; exit 0
fi
echo "FAIL"
exit 1
