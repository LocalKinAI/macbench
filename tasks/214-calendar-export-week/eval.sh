#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/214-week.ics"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 50 ]] || { echo "FAIL: file too small"; exit 2; }
if grep -qE 'BEGIN:VCALENDAR|VERSION:2\.0' "$F"; then
  echo "PASS: ICS file produced"; exit 0
fi
echo "FAIL: doesn't look like ICS format"
exit 3
