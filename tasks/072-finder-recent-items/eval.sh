#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/072-opened.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
content="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "opened path written: $content"
if printf '%s' "$content" | /usr/bin/grep -q "072-recent-target.txt"; then
  echo "PASS: target file path was reported as opened"
  exit 0
fi
echo "FAIL: report doesn't reference 072-recent-target.txt"
exit 2
