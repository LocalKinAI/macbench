#!/usr/bin/env bash
# Snapshot active resolution via system_profiler.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
RES="$(system_profiler SPDisplaysDataType 2>/dev/null | grep -iE 'Resolution|UI Looks like' | head -2)"
echo "$RES" > "$HOME/.kinbench/259-pre-display"
echo "→ pre-display:"
echo "$RES"
