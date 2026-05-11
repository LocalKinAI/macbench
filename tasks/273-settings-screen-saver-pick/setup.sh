#!/usr/bin/env bash
# Snapshot the current screen saver module.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults -currentHost read com.apple.screensaver moduleDict 2>/dev/null | grep moduleName | awk -F\" '{print $2}')"
[[ -z "$PRE" ]] && PRE="Flurry"
echo "$PRE" > "$HOME/.kinbench/273-pre-saver"
echo "→ pre-screen-saver-module: $PRE"
