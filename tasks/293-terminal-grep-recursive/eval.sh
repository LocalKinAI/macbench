#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/293-matches.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
HITS=0
for n in match-1.txt match-2.txt; do
  grep -q "$n" "$F" && HITS=$((HITS+1))
done
echo "matches: $HITS / 2"
if [[ "$HITS" -eq 2 ]]; then
  if grep -q "distractor.txt" "$F"; then echo "FAIL: distractor in output"; exit 2; fi
  echo "PASS"; exit 0
fi
echo "FAIL: missing matches"
exit 3
