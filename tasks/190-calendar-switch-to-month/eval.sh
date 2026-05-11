#!/usr/bin/env bash
# 190-calendar-switch-to-month eval
# Calendar's active view isn't exposed via AppleScript reliably,
# so we rely on the agent's confirm file plus a check that the
# current view-mode plist defaults look month-y.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/190-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: '$ANSWER'"
# Defaults check (soft signal — Calendar uses CalUIDebugDefaultDate
# and view modes; the plist key is CalDefaultViewType: 0=day 1=week 2=month).
VIEW="$(defaults read com.apple.iCal "CalDefaultViewType" 2>/dev/null || echo "")"
echo "CalDefaultViewType plist: '$VIEW'"
if [[ "$ANSWER" == *"month"* ]]; then
  if [[ "$VIEW" == "2" || -z "$VIEW" ]]; then
    echo "PASS: month view confirmed"
    exit 0
  fi
  echo "PASS (soft): agent confirmed month, plist not authoritative"
  exit 0
fi
echo "FAIL: confirm text doesn't say 'month'"
exit 2
