#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/347-confirm.txt"
osascript -e 'tell application "Photos" to activate' 2>/dev/null || true
echo "-> ready"
