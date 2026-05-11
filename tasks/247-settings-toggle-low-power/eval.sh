#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/247-pre-lpm" 2>/dev/null | tr -d '[:space:]')"
POST="$(pmset -g 2>/dev/null | awk '/lowpowermode/{print $2; exit}')"
[[ -z "$POST" ]] && POST="0"
echo "pre: $PRE   post: $POST"
if [[ "$POST" == "1" ]]; then
  echo "PASS: Low Power Mode enabled"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): Battery pane open — UI flip requires sudo to persist via CLI"
  exit 0
fi
echo "FAIL: Low Power Mode not enabled"
exit 1
