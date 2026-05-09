#!/usr/bin/env bash
# Stash current bottom-right hot corner action.
# Dock keys: wvous-br-corner = bottom-right action ID
#   0 = none, 2 = mission control, 4 = desktop, 5 = start screen saver,
#   6 = disable saver, 7 = dashboard, 10 = put display to sleep,
#   11 = launchpad, 12 = notification center, 13 = lock screen,
#   14 = quick note
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.dock wvous-br-corner 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/041-pre-corner"
echo "→ pre bottom-right corner: $PRE"
