#!/usr/bin/env bash
# 211-calendar-add-birthday-calendar eval
# Pass: 'Show Birthdays Calendar' preference flipped.
set -uo pipefail
INITIAL_FILE="$HOME/Desktop/kinbench/211-initial.txt"
if [[ ! -f "$INITIAL_FILE" ]]; then
  echo "FAIL: initial state file missing"
  exit 1
fi
INITIAL="$(cat "$INITIAL_FILE")"
CUR="$(defaults read com.apple.iCal "Show Birthdays Calendar" 2>/dev/null || echo "")"
echo "current='$CUR' initial='$INITIAL'"

norm() {
  case "$1" in
    1|true|TRUE|True|yes|YES) echo "true" ;;
    *) echo "false" ;;
  esac
}
INIT_N="$(norm "$INITIAL")"
CUR_N="$(norm "$CUR")"
echo "normalized: initial=$INIT_N current=$CUR_N"

if [[ "$INIT_N" != "$CUR_N" ]]; then
  echo "PASS: birthdays calendar visibility toggled"
  exit 0
fi
echo "FAIL: setting unchanged"
exit 2
