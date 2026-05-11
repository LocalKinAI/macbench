#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/354-recent.txt"
# Pre-baseline: how many favorites currently?
PRE="$(osascript -e 'tell application "Photos" to count of (every media item whose favorite = true)' 2>/dev/null | tr -d '[:space:]')"
echo "${PRE:-0}" > "$HOME/.kinbench/354-pre-fav"
echo "-> pre-favorites: ${PRE:-0}"
