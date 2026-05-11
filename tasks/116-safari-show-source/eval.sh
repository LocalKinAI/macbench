#!/usr/bin/env bash
# Pass: source file exists, non-trivial size, and contains <html / <body markers.
set -uo pipefail
F="$HOME/Desktop/kinbench/116-source.html"
if [ ! -s "$F" ]; then
  echo "FAIL: $F missing or empty"
  exit 1
fi
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
echo "source size: $SIZE bytes"
if [ "$SIZE" -lt 100 ]; then
  echo "FAIL: source file too small"
  exit 2
fi
if grep -qi "<html\|<body\|Example Domain" "$F"; then
  echo "PASS: html source captured"
  exit 0
fi
echo "FAIL: file lacks html markers"
exit 3
