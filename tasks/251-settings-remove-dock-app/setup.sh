#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
# Add TextEdit if not in dock so we have something to remove
if ! defaults read com.apple.dock persistent-apps 2>/dev/null | grep -q TextEdit; then
  defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/TextEdit.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' 2>/dev/null || true
  killall Dock 2>/dev/null || true
  sleep 1
fi
PRE=$(defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c TextEdit || echo 0)
echo "$PRE" > "$HOME/.kinbench/251-pre"
echo "→ pre TextEdit count: $PRE"
