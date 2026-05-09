#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/085-rename"
for f in apex bravo cedar; do
  [[ -f "$DIR/${f}.txt" ]] || { echo "FAIL: $DIR/${f}.txt missing"; exit 1; }
done
for f in original-a original-b original-c; do
  [[ ! -f "$DIR/${f}.txt" ]] || { echo "FAIL: $DIR/${f}.txt still exists"; exit 2; }
done
# Verify content order: apex came from original-a, bravo from original-b...
[[ "$(cat "$DIR/apex.txt")" == "original-a" ]] || { echo "FAIL: apex content mismatch"; exit 3; }
[[ "$(cat "$DIR/bravo.txt")" == "original-b" ]] || { echo "FAIL: bravo content mismatch"; exit 4; }
[[ "$(cat "$DIR/cedar.txt")" == "original-c" ]] || { echo "FAIL: cedar content mismatch"; exit 5; }
echo "PASS: 3 files renamed in correct order"
exit 0
