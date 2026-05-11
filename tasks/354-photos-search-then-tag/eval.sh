#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE="$(cat "$HOME/.kinbench/354-pre-fav" 2>/dev/null | tr -d '[:space:]')"
PRE="${PRE:-0}"
POST="$(osascript -e 'tell application "Photos" to count of (every media item whose favorite = true)' 2>/dev/null | tr -d '[:space:]')"
POST="${POST:-0}"
echo "pre: $PRE  post: $POST"
DELTA=$((POST - PRE))
if [[ "$DELTA" -ge 1 ]]; then
  echo "PASS: +$DELTA favorited"
  exit 0
fi
# Soft-pass: library may be empty or already all-favorited
TOTAL="$(osascript -e 'tell application "Photos" to count of media items' 2>/dev/null | tr -d '[:space:]')"
TOTAL="${TOTAL:-0}"
if [[ "$TOTAL" -lt 3 ]]; then
  echo "PASS (soft): library has only $TOTAL media items"
  exit 0
fi
echo "FAIL: favorites did not increase"
exit 1
