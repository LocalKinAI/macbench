#!/usr/bin/env bash
# Pass: the injected sentinel ("TextEdit") is no longer in the Login Items list.
# (Disabling 'Allow in the Background' for the System Settings > Login Items
# panel doesn't have a clean CLI hook; agents are expected to remove the
# Login Item entirely to demonstrate the bulk-clear gesture.)
set -uo pipefail
NOW="$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "")"
echo "current login items: $NOW"
if echo "$NOW" | grep -q "TextEdit"; then
  echo "FAIL: sentinel 'TextEdit' Login Item still present"
  exit 1
fi
echo "PASS: sentinel cleared"
exit 0
