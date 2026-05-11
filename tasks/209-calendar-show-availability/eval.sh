#!/usr/bin/env bash
# 209-calendar-show-availability eval
# Pass: file contains at least one slot in HH:MM-HH:MM 24h form,
# AND every listed slot doesn't overlap with 10:00-11:00 or
# 14:00-15:00 (the planted busy times).
set -uo pipefail
OUT="$HOME/Desktop/kinbench/209-slots.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
echo "file content:"
cat "$OUT"
echo "----"

# Extract HH:MM-HH:MM matches
SLOTS=$(grep -Eo '[0-9]{1,2}:[0-9]{2}-[0-9]{1,2}:[0-9]{2}' "$OUT" || true)
if [[ -z "$SLOTS" ]]; then
  echo "FAIL: no HH:MM-HH:MM patterns found"
  exit 2
fi

COUNT=$(printf '%s\n' "$SLOTS" | wc -l | tr -d ' ')
echo "found $COUNT slots"

# For each slot, parse start hour and check it's not 10 or 14 (the busy hours)
BAD=0
while IFS= read -r slot; do
  [[ -z "$slot" ]] && continue
  start_hour=$(printf '%s' "$slot" | awk -F'[:-]' '{print $1}')
  start_min=$(printf '%s' "$slot" | awk -F'[:-]' '{print $2}')
  start_minute_total=$((10#$start_hour * 60 + 10#$start_min))
  # Conflict if slot start falls within busy ranges (overlap simplified)
  # Busy 1: 10:00-11:00 = 600-660
  # Busy 2: 14:00-15:00 = 840-900
  # Free 1h slot must end before busy starts OR begin at/after busy ends
  end_total=$((start_minute_total + 60))
  if   ( [[ $start_minute_total -lt 660 ]] && [[ $end_total -gt 600 ]] ); then
    echo "BAD slot overlaps 10:00-11:00: $slot"
    BAD=$((BAD+1))
  elif ( [[ $start_minute_total -lt 900 ]] && [[ $end_total -gt 840 ]] ); then
    echo "BAD slot overlaps 14:00-15:00: $slot"
    BAD=$((BAD+1))
  fi
done <<< "$SLOTS"

if [[ $BAD -eq 0 ]]; then
  echo "PASS: $COUNT free slot(s), none overlap busy times"
  exit 0
fi
echo "FAIL: $BAD slot(s) overlap busy ranges"
exit 3
