#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/253-pre" 2>/dev/null | tr -d '[:space:]')"
defaults write com.apple.dock tilesize -float "${PRE:-48}"
killall Dock 2>/dev/null || true
