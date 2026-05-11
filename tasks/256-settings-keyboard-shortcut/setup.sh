#!/usr/bin/env bash
# Clear any pre-existing 'About Safari' shortcut so the change is observable.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.Safari NSUserKeyEquivalents 2>/dev/null || echo '{}')"
echo "$PRE" > "$HOME/.kinbench/256-pre-shortcut"
# Strip any existing About Safari binding to force a real write
defaults delete com.apple.Safari NSUserKeyEquivalents 2>/dev/null || true
echo "→ pre-shortcuts: $PRE"
