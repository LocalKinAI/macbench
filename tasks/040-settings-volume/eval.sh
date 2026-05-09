#!/usr/bin/env bash
set -uo pipefail
VOL="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "?")"
echo "post-volume: $VOL"
# Accept 45-55% as 'about 50%'.
if [[ "$VOL" =~ ^[0-9]+$ ]] && (( VOL >= 45 && VOL <= 55 )); then
  echo "PASS: volume ≈50%"
  exit 0
fi
echo "FAIL: volume not 50% (got $VOL)"
exit 1
