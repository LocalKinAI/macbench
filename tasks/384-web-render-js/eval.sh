#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/384-body.txt"
[[ -f "$OUT" ]] || { echo "FAIL: $OUT missing"; exit 1; }
sz=$(stat -f%z "$OUT" 2>/dev/null)
echo "size: ${sz} bytes"
if grep -qi "Example Domain" "$OUT"; then
  echo "PASS: rendered body has expected text"
  exit 0
fi
echo "FAIL: body doesn't contain Example Domain"
exit 2
