#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/025-greeting.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
CONTENT="$(head -n 1 "$F" | tr -d '\r')"
echo "first line: '$CONTENT'"
# Trim any leading/trailing whitespace; case-insensitive substring match.
# Trim + lowercase via tr (bash 3.2 compatible — ${VAR,,} is bash 4+
# and macOS still ships bash 3.2 by default).
NORM="$(echo "$CONTENT" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr '[:upper:]' '[:lower:]')"
if echo "$NORM" | grep -q "hello from kinbench"; then
  echo "PASS: greeting present"
  exit 0
fi
echo "FAIL: '$NORM' doesn't contain 'hello from kinbench'"
exit 2
