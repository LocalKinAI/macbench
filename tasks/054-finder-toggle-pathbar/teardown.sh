#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/054-pre" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in
  1|true|TRUE|YES) defaults write com.apple.finder ShowPathbar -bool true ;;
  *) defaults write com.apple.finder ShowPathbar -bool false ;;
esac
