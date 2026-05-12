#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/383-text.txt"
[[ -f "$OUT" ]] || { echo "FAIL: $OUT missing"; exit 1; }
sz=$(stat -f%z "$OUT" 2>/dev/null)
echo "size: ${sz} bytes"
# Scrapling output should be cleaner than raw HTML — expect "Example Domain" without HTML tags
if grep -qi "Example Domain" "$OUT" && ! grep -q "<html" "$OUT"; then
  echo "PASS: clean text extracted"
  exit 0
fi
echo "FAIL: scrape output looks raw or wrong"
exit 2
