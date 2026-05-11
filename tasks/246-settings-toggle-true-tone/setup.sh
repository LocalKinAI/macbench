#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE=""
if command -v corebrightnessdiag >/dev/null 2>&1; then
  PRE="$(corebrightnessdiag 2>/dev/null | grep -i 'TrueTone' | head -3)"
fi
echo "$PRE" > "$HOME/.kinbench/246-pre-truetone"
echo "→ pre-true-tone (corebrightnessdiag excerpt):"
echo "$PRE"
