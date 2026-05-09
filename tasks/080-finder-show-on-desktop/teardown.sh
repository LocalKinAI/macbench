#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/080-pre-disks" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in
  1|true|TRUE|YES) defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true ;;
  *) defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false ;;
esac
killall Finder 2>/dev/null || true
