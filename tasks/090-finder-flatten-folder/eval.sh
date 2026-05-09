#!/usr/bin/env bash
set -uo pipefail
FLAT="$HOME/Desktop/kinbench/090-flat"
COUNT=$(find "$FLAT" -maxdepth 1 -type f | wc -l | tr -d ' ')
echo "files in $FLAT (top level): $COUNT"
[[ "$COUNT" -eq 4 ]] || { echo "FAIL: expected 4 files, got $COUNT"; exit 1; }
# Verify each expected name is present (possibly with conflict suffix)
for stem in top inner-a deep inner-b; do
  if ! find "$FLAT" -maxdepth 1 -type f -name "${stem}*.txt" | grep -q .; then
    echo "FAIL: no file matching ${stem}*.txt"; exit 2
  fi
done
echo "PASS: 4 files flattened"
exit 0
