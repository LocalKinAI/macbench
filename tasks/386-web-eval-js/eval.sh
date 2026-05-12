#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/386-h1.txt"
[[ -f "$OUT" ]] || { echo "FAIL: $OUT missing"; exit 1; }
cat "$OUT"
if grep -qi "Example Domain" "$OUT"; then
  echo "PASS: h1 captured"
  exit 0
fi
echo "FAIL: h1 not captured"
exit 2
