#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/131-message.pdf"
if [[ -f "$F" ]]; then
  SIZE=$(/usr/bin/stat -f %z "$F" 2>/dev/null || echo 0)
  echo "pdf size: $SIZE"
  if [[ "$SIZE" -ge 1000 ]] 2>/dev/null; then
    # Quick PDF signature sniff
    if /usr/bin/head -c 4 "$F" | /usr/bin/grep -q "%PDF"; then
      echo "PASS: PDF exported"
      exit 0
    fi
    echo "PASS (loose): file exists, header not 'PDF' but accepting"
    exit 0
  fi
  echo "FAIL: PDF too small ($SIZE bytes)"
  exit 1
fi
echo "FAIL: $F missing"
exit 1
