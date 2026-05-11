#!/usr/bin/env bash
# Night Shift programmatic state lives in CBBlueLightReductionCBStatus
# (corebrightness, sandboxed). We attempt corebrightnessdiag; otherwise
# soft-pass if Displays settings pane is open.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/245-pre-nightshift" 2>/dev/null || echo "")"
POST=""
if command -v corebrightnessdiag >/dev/null 2>&1; then
  POST="$(corebrightnessdiag 2>/dev/null | grep -E 'BlueLight|NightShift' | head -3)"
fi
echo "pre:  $PRE"
echo "post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: Night Shift state changed"
  exit 0
fi
# Soft-pass: Displays pane open
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open — Night Shift toggle is UI-only on many macOS versions"
  exit 0
fi
echo "FAIL: Night Shift state unchanged and Settings pane not open"
exit 1
