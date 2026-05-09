#!/usr/bin/env bash
# Restore original tracking speed.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/022-pre-mouse" 2>/dev/null | tr -d '[:space:]')"
if [[ -n "$PRE" ]]; then
  defaults write -g com.apple.mouse.scaling -float "$PRE" 2>/dev/null || true
  echo "→ restored mouse scaling to $PRE (logout/login may be required to apply)"
fi
