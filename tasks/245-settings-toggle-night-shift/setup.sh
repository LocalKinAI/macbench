#!/usr/bin/env bash
# Record Night Shift status. corebrightnessdiag dumps current state.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE=""
if command -v corebrightnessdiag >/dev/null 2>&1; then
  PRE="$(corebrightnessdiag 2>/dev/null | grep -E 'BlueLight|NightShift' | head -3)"
fi
echo "$PRE" > "$HOME/.kinbench/245-pre-nightshift"
echo "→ pre-night-shift (corebrightnessdiag excerpt):"
echo "$PRE"
