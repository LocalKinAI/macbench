#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/255-pre" 2>/dev/null | tr -d '[:space:]')"
defaults write -g KeyRepeat -int "${PRE:-6}"
