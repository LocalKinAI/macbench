#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/088-matches.txt"
[[ -f "$F" ]] || { echo "FAIL: $F not written"; exit 1; }
echo "agent wrote:"
cat "$F"
HITS=0
for n in match-1.txt match-2.txt match-3.txt; do
  grep -q "$n" "$F" && HITS=$((HITS+1))
done
echo "matches found: $HITS / 3"
if [[ "$HITS" -eq 3 ]]; then
  # Make sure distractors NOT included
  if grep -q "non-match-distractor.txt\|kinbench-named.txt" "$F"; then
    echo "FAIL: a distractor (filename match without content) is in the list"; exit 2
  fi
  echo "PASS"; exit 0
fi
echo "FAIL: expected 3 content matches"
exit 3
