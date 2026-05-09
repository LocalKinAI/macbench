#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/249-pre" 2>/dev/null | tr -d '[:space:]')"
case "$PRE" in 1|true|TRUE|YES) defaults write com.apple.controlcenter BatteryShowPercentage -bool true ;; *) defaults write com.apple.controlcenter BatteryShowPercentage -bool false ;; esac
