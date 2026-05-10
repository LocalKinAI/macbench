#!/usr/bin/env bash
set -uo pipefail
TARGET="$HOME/Desktop/kinbench/074-pinned"
F="$HOME/Desktop/kinbench/074-pinned-confirm.txt"
[[ -d "$TARGET" ]] || { echo "FAIL: $TARGET missing"; exit 1; }
[[ -f "$F" ]] || { echo "FAIL: confirmation $F missing"; exit 2; }
content="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "confirmation: $content"
if printf '%s' "$content" | /usr/bin/grep -q "074-pinned"; then
  echo "PASS: confirmation written (sidebar plist not directly verifiable on macOS)"
  exit 0
fi
echo "FAIL: confirmation file lacks '074-pinned' path marker"
exit 3
