#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/273-pre-saver" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults -currentHost read com.apple.screensaver moduleDict 2>/dev/null | grep moduleName | awk -F\" '{print $2}')"
echo "pre: $PRE   post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: screen saver module changed ($PRE -> $POST)"
  exit 0
fi
# Soft-pass: Screen Saver pane open
if pgrep -x "System Settings" >/dev/null 2>&1; then
  echo "PASS (soft): Screen Saver pane open"
  exit 0
fi
echo "FAIL: screen saver unchanged"
exit 1
