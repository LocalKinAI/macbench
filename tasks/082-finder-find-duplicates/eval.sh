#!/usr/bin/env bash
# Pass: agent's report names BOTH pairs (a-original/a-copy and b-first/b-second)
# AND does NOT include c-unique (the non-duplicate distractor).
set -uo pipefail
F="$HOME/Desktop/kinbench/082-dupes.txt"
[[ -f "$F" ]] || { echo "FAIL: $F not written"; exit 1; }
CONTENT="$(cat "$F")"
echo "agent wrote:"
echo "$CONTENT"

A_PAIR=0
B_PAIR=0
printf '%s' "$CONTENT" | grep -q "a-original" && printf '%s' "$CONTENT" | grep -q "a-copy" && A_PAIR=1
printf '%s' "$CONTENT" | grep -q "b-first" && printf '%s' "$CONTENT" | grep -q "b-second" && B_PAIR=1

if printf '%s' "$CONTENT" | grep -q "c-unique"; then
  echo "FAIL: c-unique listed as duplicate (it isn't)"; exit 2
fi

if [[ "$A_PAIR" -eq 1 && "$B_PAIR" -eq 1 ]]; then
  echo "PASS: both duplicate pairs identified, no false positives"
  exit 0
fi
echo "FAIL: missing a duplicate pair (A=$A_PAIR, B=$B_PAIR)"
exit 3
