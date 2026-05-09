#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/058-pre-view" 2>/dev/null | tr -d '[:space:]"')"
[[ -n "$PRE" ]] && defaults write com.apple.finder FXPreferredViewStyle -string "$PRE"
