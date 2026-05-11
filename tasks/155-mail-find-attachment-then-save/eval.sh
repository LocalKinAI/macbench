#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/155-attachment.pdf"
if [[ -f "$F" ]]; then
  SIZE=$(/usr/bin/stat -f %z "$F" 2>/dev/null || echo 0)
  echo "attachment size: $SIZE"
  if [[ "$SIZE" -ge 8 ]] 2>/dev/null; then
    echo "PASS: attachment file present"
    exit 0
  fi
fi
echo "FAIL: $F missing or empty"
exit 1
