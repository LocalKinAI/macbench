#!/usr/bin/env bash
# Pass: Bluetooth state differs from pre-state.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/240-pre-bt" 2>/dev/null | tr -d '[:space:]')"

POST=""
if command -v blueutil >/dev/null 2>&1; then
  POST="$(blueutil --power 2>/dev/null || echo "")"
fi
if [[ -z "$POST" ]]; then
  POST="$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null || echo "")"
fi

echo "pre: $PRE   post: $POST"
if [[ -z "$POST" ]]; then
  echo "FAIL: couldn't read post-state"
  exit 1
fi
if [[ "$POST" != "$PRE" ]]; then
  echo "PASS: bluetooth toggled ($PRE -> $POST)"
  exit 0
fi
echo "FAIL: bluetooth unchanged"
exit 2
