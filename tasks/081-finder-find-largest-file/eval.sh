#!/usr/bin/env bash
# Pass: agent wrote a file naming the largest file (biggest.bin) and
# its size (1048576 bytes, give or take filesystem overhead).
set -uo pipefail
F="$HOME/Desktop/kinbench/081-largest.txt"
[[ -f "$F" ]] || { echo "FAIL: $F not written"; exit 1; }
CONTENT="$(cat "$F")"
echo "agent wrote:"
echo "$CONTENT" | head -5
# Match on filename appearing somewhere in the report.
if printf '%s' "$CONTENT" | grep -q "biggest.bin"; then
  echo "PASS: report names biggest.bin as the largest file"
  exit 0
fi
echo "FAIL: report doesn't mention 'biggest.bin'"
exit 2
