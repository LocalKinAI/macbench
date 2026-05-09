#!/usr/bin/env bash
# Pass: file exists and contains a path that's clearly an absolute
# directory path (starts with / and exists as a directory).
set -uo pipefail
F="$HOME/Desktop/kinbench/024-pwd.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
LINE="$(head -n 1 "$F" | tr -d '[:space:]')"
echo "first line: $LINE"
if [[ "$LINE" =~ ^/ ]] && [[ -d "$LINE" ]]; then
  echo "PASS: $F contains a real absolute path"
  exit 0
fi
echo "FAIL: file exists but content '$LINE' isn't an absolute existing path"
exit 2
