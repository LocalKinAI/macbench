#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
# Capture current setting (defaults to Google if unset)
PRE="$(defaults read com.apple.Safari SearchProviderIdentifier 2>/dev/null || echo 'com.apple.search.google')"
echo "$PRE" > "$HOME/.kinbench/108-pre"
# Force Google so DuckDuckGo selection is a real change.
defaults write com.apple.Safari SearchProviderIdentifier -string 'com.apple.search.google' 2>/dev/null || true
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript <<'APPLE' 2>/dev/null
tell application "Safari" to activate
APPLE
sleep 1
echo "→ pre engine: $PRE; forced google for clean test"
