#!/usr/bin/env bash
# 210-calendar-show-week-numbers eval
# Pass: the preference has changed from the initial value.
set -uo pipefail
INITIAL_FILE="$HOME/Desktop/kinbench/210-initial.txt"
if [[ ! -f "$INITIAL_FILE" ]]; then
  echo "FAIL: initial state file missing"
  exit 1
fi
INITIAL="$(cat "$INITIAL_FILE")"

# Read both possible keys; Calendar.app uses 'Show Week Numbers' in modern versions
V1="$(defaults read com.apple.iCal "Show Week Numbers" 2>/dev/null || echo "")"
V2="$(defaults read com.apple.iCal "n" 2>/dev/null || echo "")"
echo "Show Week Numbers='$V1'  n='$V2'  initial='$INITIAL'"

CUR=""
if [[ -n "$V1" ]]; then CUR="$V1"; fi
if [[ -z "$CUR" && -n "$V2" ]]; then CUR="$V2"; fi

# Treat 1/true as ON, 0/false/missing as OFF
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
  echo "PASS: week numbers toggled"
  exit 0
fi
echo "FAIL: setting unchanged"
exit 2
