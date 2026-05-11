#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/160-flag-count.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
C="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "flag count: '$C'"
[[ "$C" =~ ^[0-9]+$ ]] && { echo "PASS (soft): integer recorded"; exit 0; }
echo "FAIL: not integer"
exit 1
