#!/usr/bin/env bash
# Save current screensaver idle time (in seconds).
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/023-pre-saver"
echo "→ pre-idleTime: $PRE seconds"
