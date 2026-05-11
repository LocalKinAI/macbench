#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/119-year.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
YEAR="$(tr -dc '0-9' < "$F" | head -c 4)"
echo "agent answered: $YEAR"
# Accept 2001 (Cheetah, first public release) or 2000 (Public Beta). The
# canonical answer is 2001; 2000 awarded a soft pass.
if [[ "$YEAR" == "2001" ]]; then
  echo "PASS: macOS first release = 2001 (Cheetah, March 24)"
  exit 0
fi
if [[ "$YEAR" == "2000" ]]; then
  echo "PASS (soft): 2000 is the Public Beta — accept as adjacent correct answer"
  exit 0
fi
echo "FAIL: '$YEAR' is not 2001 (or 2000 for Public Beta)"
exit 2
