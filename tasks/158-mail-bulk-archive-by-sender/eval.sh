#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/158-archive-count.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
C="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "archive count: '$C'"
[[ "$C" =~ ^[0-9]+$ ]] && { echo "PASS (soft): count integer recorded"; exit 0; }
echo "FAIL: count not integer"
exit 1
