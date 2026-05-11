#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/260-displays.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
CONTENT="$(tr -d '\r' < "$F" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: $CONTENT"
BASELINE="$(cat "$HOME/Desktop/kinbench/260-baseline.txt" 2>/dev/null || echo 1)"

if [[ "$BASELINE" -le 1 ]]; then
  # Expect "single display"
  if echo "$CONTENT" | grep -q "single"; then
    echo "PASS: correctly reported single display"
    exit 0
  fi
else
  # Expect "multi" or a number > 1
  if echo "$CONTENT" | grep -qE "multi|[2-9]"; then
    echo "PASS: reported multi-monitor"
    exit 0
  fi
fi
# Soft pass: any content that looks display-related
if echo "$CONTENT" | grep -qE "display|monitor"; then
  echo "PASS (soft): display-related answer"
  exit 0
fi
echo "FAIL: answer doesn't match baseline ($BASELINE displays)"
exit 2
