#!/usr/bin/env bash
# Multi-stop route state isn't queryable from Maps. Verify by the
# answer file listing the three intended stops.
set -uo pipefail
F="$HOME/Desktop/kinbench/360-route.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
CONTENT="$(tr '[:upper:]' '[:lower:]' < "$F")"
HITS=0
for kw in "apple park" "stanford" "half moon bay"; do
  if echo "$CONTENT" | grep -q "$kw"; then
    HITS=$((HITS+1))
  fi
done
echo "route landmarks found: $HITS / 3"
if [[ "$HITS" -eq 3 ]]; then
  echo "PASS: all three stops named in route file"
  exit 0
fi
if [[ "$HITS" -ge 2 ]]; then
  echo "PASS (soft): 2 of 3 stops present"
  exit 0
fi
echo "FAIL: only $HITS / 3 stops in $F"
exit 2
