#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.dock tilesize 2>/dev/null || echo "48")"
echo "$PRE" > "$HOME/.kinbench/253-pre"
defaults write com.apple.dock tilesize -float 48
killall Dock 2>/dev/null || true
sleep 1
echo "→ pre tilesize: $PRE; forced to 48"
