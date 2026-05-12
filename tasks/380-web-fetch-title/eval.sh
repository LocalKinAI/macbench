#!/usr/bin/env bash
# Pass: file exists and contains "<title>Example Domain</title>"
set -uo pipefail
OUT="$HOME/Desktop/kinbench/380-page.html"
if [[ ! -f "$OUT" ]]; then echo "FAIL: $OUT missing"; exit 1; fi
sz=$(stat -f%z "$OUT" 2>/dev/null)
echo "size: ${sz} bytes"
if grep -qi "Example Domain" "$OUT"; then
  echo "PASS: page contains Example Domain"
  exit 0
fi
echo "FAIL: page doesn't contain expected marker"
exit 2
