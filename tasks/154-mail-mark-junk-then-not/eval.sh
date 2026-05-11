#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/154-junk-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "junked-then-unjunked" "$F"; then
  echo "PASS (soft): both actions confirmed"
  exit 0
fi
echo "FAIL"
exit 1
