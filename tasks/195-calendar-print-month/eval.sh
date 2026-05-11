#!/usr/bin/env bash
# 195-calendar-print-month eval
# Pass: a valid PDF (starts with %PDF) of nonzero size exists.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/195-month.pdf"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
SIZE=$(stat -f%z "$OUT" 2>/dev/null || stat -c%s "$OUT")
echo "PDF size: $SIZE bytes"
if [[ "$SIZE" -lt 100 ]]; then
  echo "FAIL: PDF too small ($SIZE bytes)"
  exit 2
fi
HEAD=$(head -c 4 "$OUT")
if [[ "$HEAD" == "%PDF" ]]; then
  echo "PASS: valid PDF written"
  exit 0
fi
echo "FAIL: file is not a valid PDF (header='$HEAD')"
exit 3
