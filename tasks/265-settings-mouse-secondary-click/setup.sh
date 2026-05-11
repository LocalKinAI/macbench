#!/usr/bin/env bash
# Snapshot mouse button mode + force OneButton so a real change is observable.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.AppleMultitouchMouse MouseButtonMode 2>/dev/null || echo "OneButton")"
echo "$PRE" > "$HOME/.kinbench/265-pre-mouse"
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string OneButton 2>/dev/null || true
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string OneButton 2>/dev/null || true
echo "→ pre-mouse-button-mode: $PRE (now forced OneButton)"
