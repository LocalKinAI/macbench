#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/326-deck.key"
osascript -e 'tell application "Keynote" to quit' >/dev/null 2>&1 || true
sleep 0.4
echo "→ cleared 326-deck.key"
