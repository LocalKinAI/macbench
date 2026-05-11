#!/usr/bin/env bash
# History.db is TCC-protected; primary signal is the agent's confirm file.
set -uo pipefail
F="$HOME/Desktop/kinbench/106-clear-history-confirm.txt"
if [ -s "$F" ] && grep -qi "clear\|history" "$F"; then
  echo "PASS: confirmation file present"
  exit 0
fi
echo "FAIL: confirmation file missing"
exit 1
