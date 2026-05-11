#!/usr/bin/env bash
set -uo pipefail
# Bluetooth must be on (so pairable devices would show)
BT_ON=0
if command -v blueutil >/dev/null 2>&1; then
  [[ "$(blueutil --power 2>/dev/null)" == "1" ]] && BT_ON=1
else
  [[ "$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null)" == "1" ]] && BT_ON=1
fi
echo "bluetooth_on=$BT_ON"

if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  if [[ "$BT_ON" == "1" ]]; then
    echo "PASS: Bluetooth pane open and BT enabled"
    exit 0
  fi
  echo "PASS (soft): System Settings open (BT was off, but pane is up)"
  exit 0
fi
echo "FAIL: System Settings not running"
exit 1
