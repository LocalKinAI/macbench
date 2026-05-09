#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/010-batch"
PREFIX_LEFT=$(find "$DIR" -maxdepth 1 -name 'prefix-*' | wc -l | tr -d ' ')
RENAMED=$(find "$DIR" -maxdepth 1 -name 'renamed-*' | wc -l | tr -d ' ')
echo "remaining prefix-* : $PREFIX_LEFT"
echo "renamed-* found    : $RENAMED"
if [[ "$PREFIX_LEFT" -ne 0 ]]; then
  echo "FAIL: $PREFIX_LEFT files still have prefix- (agent didn't rename them all)"
  exit 1
fi
if [[ "$RENAMED" -lt 3 ]]; then
  echo "FAIL: expected 3 renamed-* files, found $RENAMED"
  exit 2
fi
for x in A B C; do
  if [[ ! -f "$DIR/renamed-${x}.txt" ]]; then
    echo "FAIL: renamed-${x}.txt missing"
    exit 3
  fi
  ACTUAL="$(cat "$DIR/renamed-${x}.txt")"
  if [[ "$ACTUAL" != "$x" ]]; then
    echo "FAIL: renamed-${x}.txt content '$ACTUAL' != '$x' (rename mangled content)"
    exit 4
  fi
done
echo "PASS: all 3 files renamed prefix- → renamed- with content intact"
exit 0
