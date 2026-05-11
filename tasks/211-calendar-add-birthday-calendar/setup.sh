#!/usr/bin/env bash
# 211-calendar-add-birthday-calendar setup
# Force OFF so agent must turn ON. Snapshot initial.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
defaults write com.apple.iCal "Show Birthdays Calendar" -bool false 2>/dev/null || true
echo "false" > "$SANDBOX/211-initial.txt"
echo "→ Show Birthdays Calendar set to OFF"
