#!/usr/bin/env bash
# 004-settings-dark-mode teardown
#
# Restore the user's original appearance setting so the benchmark
# doesn't permanently change their preference.

set -uo pipefail
ORIG="$(cat "$HOME/.kinbench/004-orig-mode" 2>/dev/null || echo Light)"
ORIG="$(echo "$ORIG" | tr -d '[:space:]')"

if [[ "$ORIG" == "Dark" ]]; then
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true
else
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false' 2>/dev/null || true
fi

echo "→ restored mode to $ORIG"
