#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.finder ShowStatusBar 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/053-pre"
defaults write com.apple.finder ShowStatusBar -bool false
osascript -e 'tell application "Finder" to activate' 2>/dev/null || true
sleep 1
echo "→ ShowStatusBar pre-state: $PRE; forced to FALSE"
