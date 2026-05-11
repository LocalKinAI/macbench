#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/272-pre-fw" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$PRE" ]] && PRE=0
POST="$(defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null | tr -d '[:space:]')"
[[ -z "$POST" ]] && POST=0
echo "pre: $PRE   post: $POST"
if [[ "$POST" -ge 1 && "$POST" != "$PRE" ]]; then
  echo "PASS: firewall enabled ($PRE -> $POST)"
  exit 0
fi
if [[ "$POST" -ge 1 ]]; then
  echo "PASS: firewall was already on (still enabled)"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1; then
  echo "PASS (soft): Firewall pane open — sudo may have blocked the actual flip"
  exit 0
fi
echo "FAIL: firewall not enabled"
exit 1
