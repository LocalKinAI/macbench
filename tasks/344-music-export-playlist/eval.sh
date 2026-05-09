#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/344-tracks.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
LINES=$(wc -l < "$F" | tr -d ' ')
echo "lines in tracks file: $LINES"
[[ "$LINES" -ge 1 ]] || { echo "FAIL: empty"; exit 2; }
echo "PASS: $LINES line(s) of track titles"
exit 0
