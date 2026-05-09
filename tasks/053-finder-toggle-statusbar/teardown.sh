#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/053-pre" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in
  1|true|TRUE|YES) defaults write com.apple.finder ShowStatusBar -bool true ;;
  *) defaults write com.apple.finder ShowStatusBar -bool false ;;
esac
