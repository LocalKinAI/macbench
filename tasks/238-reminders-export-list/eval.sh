#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/238-list.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
HITS=0
for n in Alpha Beta Gamma; do
  grep -q "Item $n" "$F" && HITS=$((HITS+1))
done
echo "hits: $HITS / 3"
[[ "$HITS" -ge 3 ]] && { echo "PASS"; exit 0; } || { echo "FAIL: missing items"; exit 2; }
