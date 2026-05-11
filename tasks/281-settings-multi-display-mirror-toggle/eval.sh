#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/281-result.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
CONTENT="$(tr -d '\r' < "$F" | tr '[:upper:]' '[:lower:]')"
BASELINE="$(cat "$HOME/Desktop/kinbench/281-baseline.txt" 2>/dev/null || echo 1)"
echo "agent wrote: '$CONTENT'  baseline displays: $BASELINE"

if [[ "$BASELINE" -le 1 ]]; then
  if echo "$CONTENT" | grep -q "single"; then
    echo "PASS: correctly reported single display (no toggle needed)"
    exit 0
  fi
  echo "FAIL: single-display setup expected 'single display' answer"
  exit 2
else
  if echo "$CONTENT" | grep -qE "mirror|toggled"; then
    echo "PASS: mirroring action reported"
    exit 0
  fi
  echo "FAIL: multi-display setup, but no mirror-toggle confirmation in answer"
  exit 3
fi
