#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/097-pre" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in 1|true|TRUE|YES) defaults write com.apple.Safari IncludeDevelopMenu -bool true ;; *) defaults write com.apple.Safari IncludeDevelopMenu -bool false ;; esac
