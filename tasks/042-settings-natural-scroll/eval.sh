#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/042-pre-scroll" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults read -g com.apple.swipescrolldirection 2>/dev/null | tr -d '[:space:]' || echo "?")"
echo "pre: $PRE   post: $POST"
if [[ -z "$POST" || "$POST" == "?" ]]; then
  echo "FAIL: couldn't read post-state"
  exit 1
fi
if [[ "$POST" != "$PRE" ]]; then
  echo "PASS: natural-scroll flipped"
  exit 0
fi
echo "FAIL: setting unchanged"
exit 2
