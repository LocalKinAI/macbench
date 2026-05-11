#!/usr/bin/env bash
# 191-calendar-switch-to-week eval
set -uo pipefail
OUT="$HOME/Desktop/kinbench/191-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: '$ANSWER'"
VIEW="$(defaults read com.apple.iCal "CalDefaultViewType" 2>/dev/null || echo "")"
echo "CalDefaultViewType plist: '$VIEW'"
if [[ "$ANSWER" == *"week"* ]]; then
  echo "PASS: week view confirmed"
  exit 0
fi
echo "FAIL: confirm text doesn't say 'week'"
exit 2
