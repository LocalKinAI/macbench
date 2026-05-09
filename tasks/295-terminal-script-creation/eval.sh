#!/usr/bin/env bash
set -uo pipefail
S="$HOME/Desktop/kinbench/295-script.sh"
O="$HOME/Desktop/kinbench/295-output.txt"
[[ -f "$S" ]] || { echo "FAIL: $S missing"; exit 1; }
[[ -x "$S" ]] || { echo "FAIL: $S not executable"; exit 2; }
[[ -f "$O" ]] || { echo "FAIL: $O missing"; exit 3; }
if grep -qi "hello kinbench" "$O"; then
  echo "PASS: script + output produced 'hello kinbench'"
  exit 0
fi
echo "FAIL: output doesn't contain 'hello kinbench'"
exit 4
