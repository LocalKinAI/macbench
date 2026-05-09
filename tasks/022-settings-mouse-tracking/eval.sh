#!/usr/bin/env bash
# Pass: defaults value differs from pre-state.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/022-pre-mouse" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults read -g com.apple.mouse.scaling 2>/dev/null | tr -d '[:space:]')"
echo "pre: $PRE   post: $POST"
if [[ -z "$POST" ]]; then
  echo "FAIL: couldn't read post-state"
  exit 1
fi
if [[ "$POST" != "$PRE" ]]; then
  echo "PASS: tracking speed changed ($PRE → $POST)"
  exit 0
fi
echo "FAIL: tracking speed unchanged"
exit 2
