#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/161-thread.pdf"
if [[ -f "$F" ]]; then
  SIZE=$(/usr/bin/stat -f %z "$F" 2>/dev/null || echo 0)
  echo "pdf size: $SIZE"
  if [[ "$SIZE" -ge 16 ]] 2>/dev/null && /usr/bin/head -c 4 "$F" | /usr/bin/grep -q "%PDF"; then
    echo "PASS: PDF exported"
    exit 0
  fi
  if [[ "$SIZE" -ge 16 ]] 2>/dev/null; then
    echo "PASS (loose): non-empty file at path"
    exit 0
  fi
fi
echo "FAIL: $F missing or empty"
exit 1
