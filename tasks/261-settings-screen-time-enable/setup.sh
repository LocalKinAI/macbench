#!/usr/bin/env bash
# Snapshot a marker file's mtime so the eval can detect a recent edit.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
P="$HOME/Library/Application Support/ScreenTimeAgent/Setting/UserMacUsage.json"
if [[ -f "$P" ]]; then
  stat -f '%m' "$P" > "$HOME/.kinbench/261-pre-st"
else
  echo "0" > "$HOME/.kinbench/261-pre-st"
fi
echo "→ pre-screen-time-mtime: $(cat "$HOME/.kinbench/261-pre-st")"
