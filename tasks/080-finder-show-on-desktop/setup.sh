#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.finder ShowHardDrivesOnDesktop 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/080-pre-disks"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
killall Finder 2>/dev/null || true
sleep 1
echo "→ pre: $PRE; forced ShowHardDrivesOnDesktop=false"
