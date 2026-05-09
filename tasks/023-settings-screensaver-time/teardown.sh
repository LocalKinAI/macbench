#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/023-pre-saver" 2>/dev/null | tr -d '[:space:]')"
if [[ -n "$PRE" ]]; then
  defaults -currentHost write com.apple.screensaver idleTime -int "$PRE" 2>/dev/null || true
  echo "→ restored idleTime to $PRE"
fi
