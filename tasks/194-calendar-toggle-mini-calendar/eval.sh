#!/usr/bin/env bash
# 194-calendar-toggle-mini-calendar eval
# Sidebar visibility isn't exposed via AppleScript reliably; we
# rely on agent confirmation.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/194-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: '$ANSWER'"
if [[ "$ANSWER" == *"toggled"* ]] || [[ "$ANSWER" == *"toggle"* ]]; then
  echo "PASS: sidebar toggle confirmed"
  exit 0
fi
echo "FAIL: confirm text doesn't say 'toggled'"
exit 2
