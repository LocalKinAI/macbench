#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/387-readme.md"
[[ -f "$OUT" ]] || { echo "FAIL: $OUT missing"; exit 1; }
sz=$(stat -f%z "$OUT" 2>/dev/null)
echo "size: ${sz} bytes"
[[ "$sz" -lt 100 ]] && { echo "FAIL: file too small"; exit 2; }
if grep -qi "macbench" "$OUT"; then
  echo "PASS: README downloaded with expected content"
  exit 0
fi
echo "FAIL: README missing 'macbench' marker"
exit 3
