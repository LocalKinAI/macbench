#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/260-displays.txt"
# Count real displays for eval reference
COUNT=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Resolution:" || echo "1")
echo "$COUNT" > "$HOME/Desktop/kinbench/260-baseline.txt"
echo "→ baseline display count = $COUNT"
