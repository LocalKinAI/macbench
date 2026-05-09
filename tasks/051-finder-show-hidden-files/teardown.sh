#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/051-pre-hidden" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in
  1|true|TRUE|YES) defaults write com.apple.finder AppleShowAllFiles -bool true ;;
  *) defaults write com.apple.finder AppleShowAllFiles -bool false ;;
esac
killall Finder 2>/dev/null || true
echo "→ restored AppleShowAllFiles to $PRE"
