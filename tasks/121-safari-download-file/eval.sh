#!/usr/bin/env bash
# Pass: ~/Downloads/gpl-3.0.txt exists and contains GPL-3 markers.
set -uo pipefail
F="$HOME/Downloads/gpl-3.0.txt"
if [ ! -s "$F" ]; then
  echo "FAIL: $F missing or empty"
  exit 1
fi
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
echo "file size: $SIZE bytes"
if [ "$SIZE" -lt 1000 ]; then
  echo "FAIL: file suspiciously small"
  exit 2
fi
if grep -qi "GNU GENERAL PUBLIC LICENSE\|Version 3" "$F"; then
  echo "PASS: GPL-3 text downloaded"
  exit 0
fi
echo "FAIL: file lacks GPL-3 markers"
exit 3
