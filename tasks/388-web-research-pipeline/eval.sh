#!/usr/bin/env bash
set -uo pipefail
R="$HOME/Desktop/kinbench/388-research.json"
F="$HOME/Desktop/kinbench/388-first.html"
[[ -f "$R" ]] || { echo "FAIL: research json missing"; exit 1; }
[[ -f "$F" ]] || { echo "FAIL: first.html missing"; exit 2; }

N=$(jq -r 'length' "$R" 2>/dev/null)
echo "results count: $N"
[[ "${N:-0}" -ge 3 ]] || { echo "FAIL: <3 results"; exit 3; }

szF=$(stat -f%z "$F" 2>/dev/null)
echo "first.html size: ${szF} bytes"
[[ "${szF:-0}" -lt 100 ]] && { echo "FAIL: first.html too small"; exit 4; }

echo "PASS: search returned $N hits + fetched first to ${szF} bytes"
exit 0
