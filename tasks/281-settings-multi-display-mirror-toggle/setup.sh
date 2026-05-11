#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/281-result.txt"
COUNT=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Resolution:" || echo "1")
echo "$COUNT" > "$HOME/Desktop/kinbench/281-baseline.txt"
echo "→ baseline display count = $COUNT"
