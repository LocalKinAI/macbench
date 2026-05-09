#!/usr/bin/env bash
# Pass: idleTime != pre-state. (Doesn't require exactly 5min — any
# change accepts because some macOS versions don't offer 300s in
# the dropdown.)
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/023-pre-saver" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null | tr -d '[:space:]')"
echo "pre: $PRE   post: $POST"
if [[ -z "$POST" ]]; then
  echo "FAIL: couldn't read post-state"
  exit 1
fi
if [[ "$POST" != "$PRE" ]]; then
  echo "PASS: idleTime changed ($PRE → $POST)"
  exit 0
fi
echo "FAIL: idleTime unchanged"
exit 2
