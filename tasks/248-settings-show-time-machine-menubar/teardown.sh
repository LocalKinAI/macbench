#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/248-pre" 2>/dev/null | tr -d '[:space:]')"
KEY="NSStatusItem Visible TimeMachine"
case "$PRE" in 1|true|TRUE|YES) defaults write com.apple.controlcenter "$KEY" -bool true ;; *) defaults write com.apple.controlcenter "$KEY" -bool false ;; esac
