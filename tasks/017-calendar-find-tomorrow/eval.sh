#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/017-found-time.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT not written"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT")"
echo "agent wrote: '$ANSWER'"
# Accept 14:30 / 1430 / 14.30 / 02:30 PM / 2:30 PM (lower flexibility)
ANSWER_LC="$(printf '%s' "$ANSWER" | tr '[:upper:]' '[:lower:]')"
if [[ "$ANSWER" =~ 14[:.]?30 ]] || [[ "$ANSWER_LC" =~ 2[:.]?30(pm)? ]]; then
  echo "PASS: agent reported the correct time"
  exit 0
fi
echo "FAIL: '$ANSWER' doesn't match 14:30 / 2:30 PM"
exit 2
