#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/042-pre-scroll" 2>/dev/null | tr -d '[:space:]')"
if [[ "$PRE" =~ ^[01]$ ]]; then
  defaults write -g com.apple.swipescrolldirection -bool "$PRE" 2>/dev/null || true
  echo "→ restored natural-scroll to $PRE"
fi
