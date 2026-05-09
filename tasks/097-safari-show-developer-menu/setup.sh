#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.Safari IncludeDevelopMenu 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/097-pre"
defaults write com.apple.Safari IncludeDevelopMenu -bool false
echo "→ pre: $PRE; forced false"
