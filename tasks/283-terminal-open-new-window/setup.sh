#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/283-confirm.txt"
# Record baseline window count so eval can detect a new one
osascript -e 'tell application "Terminal" to count of windows' \
  > "$HOME/Desktop/kinbench/283-baseline.txt" 2>/dev/null || echo "0" > "$HOME/Desktop/kinbench/283-baseline.txt"
echo "→ baseline windows = $(cat $HOME/Desktop/kinbench/283-baseline.txt)"
