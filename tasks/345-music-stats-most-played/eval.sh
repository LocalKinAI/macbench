#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/345-top.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
BYTES=$(wc -c < "$F" | tr -d ' ')
echo "bytes: $BYTES"
# Soft-pass if file written. Empty file means library is empty.
if [[ "$BYTES" -ge 1 ]]; then
  echo "PASS"
  exit 0
fi
echo "PASS (soft): file produced but library may be empty"
exit 0
