#!/usr/bin/env bash
# Save the pre-state of AppleShowAllFiles + force it to FALSE
# so eval can detect a real toggle (whether agent flipped to TRUE).
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/051-pre-hidden"
defaults write com.apple.finder AppleShowAllFiles -bool false
killall Finder 2>/dev/null || true
sleep 1
echo "→ pre-state: $PRE; forced to FALSE"
