#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/263-pre" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in 1|true|TRUE|YES) defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true ;; *) defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false ;; esac
