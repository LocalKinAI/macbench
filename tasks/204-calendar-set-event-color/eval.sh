#!/usr/bin/env bash
# 204-calendar-set-event-color eval
# Pass: event exists in a calendar != origin.
set -uo pipefail
sleep 1
ORIGIN_FILE="$HOME/Desktop/kinbench/204-origin.txt"
if [[ ! -f "$ORIGIN_FILE" ]]; then
  echo "FAIL: origin file missing"
  exit 1
fi
ORIGIN="$(cat "$ORIGIN_FILE")"
echo "origin calendar: '$ORIGIN'"

RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set out to ""
    set total to 0
    repeat with c in calendars
        try
            repeat with ev in (every event of c whose summary = "KinBench Color 204")
                set total to total + 1
                set out to out & (name of c) & linefeed
            end repeat
        end try
    end repeat
    return (total as string) & "||" & out
end tell
APPLE
)"
COUNT="${RESULT%%||*}"
LOCS="${RESULT#*||}"
echo "matching events: $COUNT  in calendars:"
printf '%s' "$LOCS"

if [[ "$COUNT" == "0" ]]; then
  echo "FAIL: event deleted, not moved"
  exit 2
fi

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" != "$ORIGIN" ]]; then
    echo "PASS: event moved from '$ORIGIN' to '$line' (different color)"
    exit 0
  fi
done <<< "$LOCS"

echo "FAIL: event still in origin '$ORIGIN'"
exit 3
