#!/usr/bin/env bash
# 210-calendar-show-week-numbers setup
# Force week-numbers OFF so agent must turn it ON (or vice versa).
# We snapshot the initial value so eval can verify it flipped.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
# Force OFF as starting state
defaults write com.apple.iCal "Show Week Numbers" -bool false 2>/dev/null || true
defaults write com.apple.iCal "n" -bool false 2>/dev/null || true
echo "false" > "$SANDBOX/210-initial.txt"
echo "→ week numbers set to OFF (initial state recorded)"
