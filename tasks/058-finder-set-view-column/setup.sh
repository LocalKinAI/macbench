#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null || echo "icnv")"
echo "$PRE" > "$HOME/.kinbench/058-pre-view"
# Force a different starting view so agent has to switch.
defaults write com.apple.finder FXPreferredViewStyle -string icnv
osascript -e 'tell application "Finder" to activate' 2>/dev/null || true
sleep 1
echo "→ FXPreferredViewStyle pre: $PRE; forced to icnv (icon view)"
