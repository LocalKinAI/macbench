#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/290-version.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
CONTENT="$(cat "$F")"
echo "wrote: $CONTENT"
# Look for "Version:" or "version" line from pip3 show output
if grep -qi "version" "$F"; then
  echo "PASS: pip output captured"
  exit 0
fi
echo "FAIL: no version-shaped string in output"
exit 2
