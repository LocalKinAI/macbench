#!/usr/bin/env bash
# 196-calendar-go-to-date eval
set -uo pipefail
OUT="$HOME/Desktop/kinbench/196-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT")"
echo "agent wrote: '$ANSWER'"
# Accept 2027-03-15, 20270315, 03/15/2027, 03-15-2027, March 15 2027
ANSWER_LC="$(printf '%s' "$ANSWER" | tr '[:upper:]' '[:lower:]')"
if [[ "$ANSWER" == *"2027-03-15"* ]] \
   || [[ "$ANSWER" == *"20270315"* ]] \
   || [[ "$ANSWER" == *"03/15/2027"* ]] \
   || [[ "$ANSWER" == *"03-15-2027"* ]] \
   || [[ "$ANSWER" == *"3/15/2027"* ]] \
   || [[ "$ANSWER_LC" == *"march15"*"2027"* ]] \
   || [[ "$ANSWER_LC" == *"march152027"* ]] \
   || [[ "$ANSWER_LC" == *"mar15"*"2027"* ]]; then
  echo "PASS: confirmed go-to-date 2027-03-15"
  exit 0
fi
echo "FAIL: confirm text doesn't reference 2027-03-15"
exit 2
