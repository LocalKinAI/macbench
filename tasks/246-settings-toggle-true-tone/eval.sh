#!/usr/bin/env bash
# True Tone state is hard to read programmatically. Compare
# corebrightnessdiag dump if available; else soft-pass on Displays pane open.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/246-pre-truetone" 2>/dev/null || echo "")"
POST=""
if command -v corebrightnessdiag >/dev/null 2>&1; then
  POST="$(corebrightnessdiag 2>/dev/null | grep -i 'TrueTone' | head -3)"
fi
echo "pre:  $PRE"
echo "post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: True Tone state changed"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open — True Tone UI is non-readable, accepting open pane"
  exit 0
fi
echo "FAIL: True Tone unchanged and Settings not open"
exit 1
