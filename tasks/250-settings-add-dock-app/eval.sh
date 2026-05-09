#!/usr/bin/env bash
set -uo pipefail
PRE=$(cat "$HOME/.kinbench/250-pre-count" 2>/dev/null | tr -d '[:space:]')
POST=$(defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c 'TextEdit' || echo "0")
echo "pre count: $PRE  post count: $POST"
if [[ "$POST" -gt "$PRE" ]]; then
  echo "PASS: TextEdit added to dock"; exit 0
fi
echo "FAIL: TextEdit count didn't increase"
exit 1
