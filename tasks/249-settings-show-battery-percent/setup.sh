#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults -currentHost read -g AppleSpacesShowingPercentage 2>/dev/null || \
       defaults read com.apple.controlcenter BatteryShowPercentage 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/249-pre"
defaults write com.apple.controlcenter BatteryShowPercentage -bool false
echo "→ pre: $PRE; forced to false"
