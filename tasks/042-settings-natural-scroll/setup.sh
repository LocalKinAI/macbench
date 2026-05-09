#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read -g com.apple.swipescrolldirection 2>/dev/null || echo "1")"
echo "$PRE" > "$HOME/.kinbench/042-pre-scroll"
echo "→ pre natural-scroll value: $PRE"
