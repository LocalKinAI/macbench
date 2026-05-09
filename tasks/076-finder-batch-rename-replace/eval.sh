#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/076-files"
DRAFT_LEFT=$(find "$DIR" -maxdepth 1 -name 'draft-*' | wc -l | tr -d ' ')
FINAL=$(find "$DIR" -maxdepth 1 -name 'final-*' | wc -l | tr -d ' ')
echo "draft-* remaining: $DRAFT_LEFT  final-*: $FINAL"
if [[ "$DRAFT_LEFT" -ne 0 ]]; then echo "FAIL: $DRAFT_LEFT files still have draft- prefix"; exit 1; fi
if [[ "$FINAL" -lt 3 ]]; then echo "FAIL: expected 3 final-* files, found $FINAL"; exit 2; fi
for x in alpha beta gamma; do
  [[ -f "$DIR/final-${x}.txt" ]] || { echo "FAIL: final-${x}.txt missing"; exit 3; }
  CONTENT="$(cat "$DIR/final-${x}.txt")"
  [[ "$CONTENT" == "$x" ]] || { echo "FAIL: final-${x}.txt content '$CONTENT' != '$x'"; exit 4; }
done
echo "PASS: 3 files renamed draft- → final-"
exit 0
