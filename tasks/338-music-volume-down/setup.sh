#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
# Set a baseline of 70 so we have headroom to go down.
osascript -e 'tell application "Music" to set sound volume to 70' 2>/dev/null || true
sleep 0.4
PRE="$(osascript -e 'tell application "Music" to sound volume' 2>/dev/null)"
echo "${PRE:-70}" > "$HOME/.kinbench/338-pre"
echo "-> pre volume: ${PRE:-70}"
