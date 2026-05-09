#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/052-pre-sidebar" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in
  0|false|FALSE|NO) defaults write com.apple.finder ShowSidebar -bool false ;;
  *) defaults write com.apple.finder ShowSidebar -bool true ;;
esac
echo "→ restored ShowSidebar to $PRE"
