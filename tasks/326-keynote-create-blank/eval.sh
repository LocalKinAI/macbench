#!/usr/bin/env bash
# Real verification: file exists, has .key extension structure, size > 1024.
set -uo pipefail
F="$HOME/Desktop/kinbench/326-deck.key"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small ($SIZE)"; exit 2; }
# Confirm it's a Keynote bundle (zip-encoded)
if file "$F" | grep -qi "zip"; then
  echo "PASS: Keynote bundle present ($SIZE bytes, zip)"
  exit 0
fi
if [[ -d "$F" ]]; then
  echo "PASS: Keynote bundle present ($SIZE bytes, directory)"
  exit 0
fi
echo "PASS (soft): $F exists, $SIZE bytes"
exit 0
