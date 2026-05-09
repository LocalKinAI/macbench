#!/usr/bin/env bash
# Stash current volume so we can restore + force a clearly-different
# starting value (10%) so the agent has to make a real change.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "100")"
echo "$PRE" > "$HOME/.kinbench/040-pre-vol"
osascript -e 'set volume output volume 10' 2>/dev/null || true
echo "→ pre-volume saved ($PRE), forced to 10%"
