#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read -g KeyRepeat 2>/dev/null || echo "6")"
echo "$PRE" > "$HOME/.kinbench/255-pre"
defaults write -g KeyRepeat -int 6
echo "→ pre KeyRepeat: $PRE; forced to 6 (slow)"
