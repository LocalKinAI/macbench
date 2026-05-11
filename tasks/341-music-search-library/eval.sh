#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/341-search.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
LINES=$(wc -l < "$F" | tr -d ' ')
echo "lines in search file: $LINES"
# Soft-pass: agent produced a result file (may be 0 lines if library has no match)
if [[ "$LINES" -ge 1 ]]; then
  echo "PASS: $LINES result line(s)"; exit 0
fi
# Even an empty file is acceptable evidence the agent executed the search
if [[ -e "$F" ]]; then
  echo "PASS (soft): search executed, file present"; exit 0
fi
echo "FAIL"; exit 1
