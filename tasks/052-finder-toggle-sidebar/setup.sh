#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
# ShowSidebar is set per-window via View menu, but Finder also stores
# a global "first window default" in com.apple.finder ShowSidebar.
# Save the current global value + force a known starting state.
PRE="$(defaults read com.apple.finder ShowSidebar 2>/dev/null || echo "1")"
echo "$PRE" > "$HOME/.kinbench/052-pre-sidebar"
# Force sidebar visible so agent has to hide it (or vice versa).
defaults write com.apple.finder ShowSidebar -bool true
osascript -e 'tell application "Finder" to activate' 2>/dev/null || true
sleep 1
echo "→ pre-state: $PRE; forced sidebar to visible"
