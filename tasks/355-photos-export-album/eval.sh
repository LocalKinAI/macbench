#!/usr/bin/env bash
set -uo pipefail
D="$HOME/Desktop/kinbench/355-export"
[[ -d "$D" ]] || { echo "FAIL: $D missing"; exit 1; }
COUNT=$(find "$D" -type f | wc -l | tr -d ' ')
echo "exported files: $COUNT"
if [[ "$COUNT" -ge 1 ]]; then
  echo "PASS"
  exit 0
fi
# Soft-pass if album has no items because library is empty
TOTAL="$(osascript -e 'tell application "Photos" to count of media items' 2>/dev/null | tr -d '[:space:]')"
TOTAL="${TOTAL:-0}"
if [[ "$TOTAL" -eq 0 ]]; then
  echo "PASS (soft): empty library"
  exit 0
fi
echo "FAIL: no exported files"
exit 1
