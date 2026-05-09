#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.dock orientation 2>/dev/null || echo "bottom")"
echo "$PRE" > "$HOME/.kinbench/252-pre"
defaults write com.apple.dock orientation -string "bottom"
killall Dock 2>/dev/null || true
sleep 1
echo "→ pre: $PRE; forced to bottom"
