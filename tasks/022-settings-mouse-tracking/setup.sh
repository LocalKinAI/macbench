#!/usr/bin/env bash
# Save the current mouse tracking speed so eval can compare.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
defaults read -g com.apple.mouse.scaling 2>/dev/null > "$HOME/.kinbench/022-pre-mouse" || echo "0.875" > "$HOME/.kinbench/022-pre-mouse"
echo "→ pre-tracking-speed: $(cat "$HOME/.kinbench/022-pre-mouse")"
