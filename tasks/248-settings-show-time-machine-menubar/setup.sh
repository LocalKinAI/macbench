#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
KEY="NSStatusItem Visible TimeMachine"
PRE="$(defaults read com.apple.controlcenter "$KEY" 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/248-pre"
defaults write com.apple.controlcenter "$KEY" -bool false
echo "→ pre: $PRE; forced to false"
