#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.finder ShowPathbar 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/054-pre"
defaults write com.apple.finder ShowPathbar -bool false
osascript -e 'tell application "Finder" to activate' 2>/dev/null || true
sleep 1
echo "→ ShowPathbar pre-state: $PRE; forced to FALSE"
