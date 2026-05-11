#!/usr/bin/env bash
# 206-calendar-respond-invitation eval
# Pass: event description contains 'ACCEPTED' (case-insensitive).
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Invite 206")
                return (description of ev)
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "description: '$RESULT'"
RES_LC="$(printf '%s' "$RESULT" | tr '[:upper:]' '[:lower:]')"
if [[ "$RES_LC" == *"accepted"* ]]; then
  echo "PASS: invitation accepted"
  exit 0
fi
echo "FAIL: description doesn't say ACCEPTED"
exit 1
