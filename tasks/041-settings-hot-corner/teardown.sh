#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/041-pre-corner" 2>/dev/null | tr -d '[:space:]')"
if [[ "$PRE" =~ ^[0-9]+$ ]]; then
  defaults write com.apple.dock wvous-br-corner -int "$PRE" 2>/dev/null || true
  killall Dock 2>/dev/null || true
  echo "→ restored bottom-right corner to $PRE"
fi
