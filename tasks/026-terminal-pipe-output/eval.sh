#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/026-count.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$F")"
echo "agent wrote: '$ANSWER'"
if [[ "$ANSWER" == "7" ]]; then
  echo "PASS: counted .txt files correctly"
  exit 0
fi
echo "FAIL: expected 7, got '$ANSWER' (likely counted non-.txt files too)"
exit 2
