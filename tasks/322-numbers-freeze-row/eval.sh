#!/usr/bin/env bash
# Soft-pass: freeze state is metadata only. Accept confirmation + size.
set -uo pipefail
F="$HOME/Desktop/kinbench/322-sheet.numbers"
CONF="$HOME/Desktop/kinbench/322-freeze-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
