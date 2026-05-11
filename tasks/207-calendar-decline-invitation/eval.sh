#!/usr/bin/env bash
# 207-calendar-decline-invitation eval
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Invite 207")
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
if [[ "$RES_LC" == *"declined"* ]]; then
  echo "PASS: invitation declined"
  exit 0
fi
echo "FAIL: description doesn't say DECLINED"
exit 1
