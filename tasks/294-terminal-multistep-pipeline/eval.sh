#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/294-top5.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
LINES=$(wc -l < "$F" | tr -d ' ')
echo "lines in report: $LINES"
[[ "$LINES" -ge 4 && "$LINES" -le 6 ]] || { echo "FAIL: expected ~5 lines"; exit 2; }
# Top 5 should be file-4 through file-8 (sizes 40K..80K)
HITS=0
for n in 4 5 6 7 8; do
  grep -q "file-${n}" "$F" && HITS=$((HITS+1))
done
echo "top-5 hits: $HITS / 5"
[[ "$HITS" -ge 4 ]] || { echo "FAIL: agent didn't identify top 5 by size"; exit 3; }
echo "PASS"; exit 0
