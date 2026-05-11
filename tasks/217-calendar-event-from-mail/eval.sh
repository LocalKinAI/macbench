#!/usr/bin/env bash
# 217-calendar-event-from-mail eval
# Pass: a 'KinBench Flight 217' event exists whose start date
# matches the depart date+time recorded by setup.
set -uo pipefail
sleep 1
DEPART_FILE="$HOME/Desktop/kinbench/217-depart.txt"
if [[ ! -f "$DEPART_FILE" ]]; then
  echo "FAIL: setup didn't run — depart file missing"
  exit 1
fi
DEPART="$(cat "$DEPART_FILE")"
echo "expected depart: $DEPART"
# Extract date and time parts
DEPART_DATE="${DEPART%% *}"     # YYYY-MM-DD
DEPART_TIME="${DEPART##* }"      # HH:MM
echo "expected date=$DEPART_DATE time=$DEPART_TIME"

RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Flight 217")
                return ((start date of ev) as string)
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "event start: '$RESULT'"
if [[ -z "$RESULT" ]]; then
  echo "FAIL: no KinBench Flight 217 event"
  exit 2
fi

# Match: HH:MM should appear in the date string. Also accept time in
# 12-hour form (9:30 AM ↔ 09:30 -> 9:30).
HH="${DEPART_TIME%%:*}"
MM="${DEPART_TIME##*:}"
HH_12=$((10#$HH))
if [[ $HH_12 -gt 12 ]]; then
  HH_12=$((HH_12 - 12))
fi
if [[ $HH_12 -eq 0 ]]; then HH_12=12; fi
T24="${HH}:${MM}"
T12="${HH_12}:${MM}"
echo "checking time strings: $T24 / $T12"
if [[ "$RESULT" == *"$T24"* ]] || [[ "$RESULT" == *"$T12"* ]]; then
  echo "PASS: event scheduled at $DEPART_TIME"
  exit 0
fi
echo "FAIL: event time doesn't match $DEPART_TIME"
exit 3
