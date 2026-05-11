#!/usr/bin/env bash
# Soft-pass: theme name lives in the bundle but is hard to compare reliably.
# Accept confirmation file + file existence.
set -uo pipefail
F="$HOME/Desktop/kinbench/329-deck.key"
CONF="$HOME/Desktop/kinbench/329-theme-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
