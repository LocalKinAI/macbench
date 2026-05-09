#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.AppleMultitouchTrackpad Clicking 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/263-pre"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
echo "→ pre: $PRE; forced tap-to-click off"
