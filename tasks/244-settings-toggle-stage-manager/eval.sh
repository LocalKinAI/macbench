#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/244-pre-stage" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults read com.apple.WindowManager GloballyEnabled 2>/dev/null | tr -d '[:space:]')"
echo "pre: $PRE   post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: Stage Manager toggled ($PRE -> $POST)"
  exit 0
fi
echo "FAIL: Stage Manager unchanged"
exit 1
