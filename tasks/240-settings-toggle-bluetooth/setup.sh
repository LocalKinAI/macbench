#!/usr/bin/env bash
# Save current Bluetooth power state so eval can detect the toggle.
set -uo pipefail
mkdir -p "$HOME/.kinbench"

PRE=""
if command -v blueutil >/dev/null 2>&1; then
  PRE="$(blueutil --power 2>/dev/null || echo "")"
fi
if [[ -z "$PRE" ]]; then
  PRE="$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null || echo "")"
fi
[[ -z "$PRE" ]] && PRE="1"
echo "$PRE" > "$HOME/.kinbench/240-pre-bt"
echo "→ pre-bluetooth: $PRE (0=off, 1=on)"
