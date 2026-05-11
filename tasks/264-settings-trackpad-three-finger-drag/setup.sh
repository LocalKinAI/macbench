#!/usr/bin/env bash
# Snapshot pre-state and force OFF so the eval can detect a real enable.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/264-pre-3fd"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false 2>/dev/null || true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false 2>/dev/null || true
echo "→ pre-3fd: $PRE (now forced false)"
