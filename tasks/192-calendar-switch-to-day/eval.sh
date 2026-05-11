#!/usr/bin/env bash
# 192-calendar-switch-to-day eval
set -uo pipefail
OUT="$HOME/Desktop/kinbench/192-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: '$ANSWER'"
if [[ "$ANSWER" == *"day"* ]]; then
  echo "PASS: day view confirmed"
  exit 0
fi
echo "FAIL: confirm text doesn't say 'day'"
exit 2
