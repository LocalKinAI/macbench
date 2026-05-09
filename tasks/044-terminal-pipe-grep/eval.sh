#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/044-count.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$F")"
echo "agent wrote: '$ANSWER'"
if [[ "$ANSWER" == "5" ]]; then
  echo "PASS: counted exactly 5 case-sensitive matches"
  exit 0
fi
echo "FAIL: expected 5, got '$ANSWER' (likely missed case-sensitive constraint)"
exit 2
