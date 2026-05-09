#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
defaults read com.apple.dock persistent-apps 2>/dev/null > "$HOME/.kinbench/250-pre" || true
# Strip TextEdit from current dock so agent has to add it.
defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c 'TextEdit' > "$HOME/.kinbench/250-pre-count" || echo "0" > "$HOME/.kinbench/250-pre-count"
echo "→ pre TextEdit count: $(cat "$HOME/.kinbench/250-pre-count")"
