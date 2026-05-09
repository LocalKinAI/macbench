#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/252-pre" 2>/dev/null | tr -d '[:space:]')"
defaults write com.apple.dock orientation -string "${PRE:-bottom}"
killall Dock 2>/dev/null || true
