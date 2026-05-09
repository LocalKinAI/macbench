#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/040-pre-vol" 2>/dev/null | tr -d '[:space:]')"
if [[ "$PRE" =~ ^[0-9]+$ ]]; then
  osascript -e "set volume output volume $PRE" 2>/dev/null || true
  echo "→ restored volume to $PRE%"
fi
