#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/063-found-path.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
content="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "found path: $content"
expected="kinbench-spotlight-063.txt"
if printf '%s' "$content" | /usr/bin/grep -q "$expected"; then
  # Also verify the path actually exists on disk (not made up)
  reported="$(/bin/cat "$F" | /usr/bin/head -1 | /usr/bin/sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  if [[ -f "$reported" ]]; then
    echo "PASS: located + path exists"
    exit 0
  fi
  echo "FAIL: reported path '$reported' doesn't exist"
  exit 2
fi
echo "FAIL: result file lacks '$expected'"
exit 3
