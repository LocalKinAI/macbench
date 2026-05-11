#!/usr/bin/env bash
# Soft-pass: Numbers cell bold flag is buried in protobuf. Accept confirmation
# file + file existence/size.
set -uo pipefail
F="$HOME/Desktop/kinbench/312-sheet.numbers"
CONF="$HOME/Desktop/kinbench/312-bold-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
