#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.WindowManager GloballyEnabled 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/244-pre-stage"
echo "→ pre-stage-manager: $PRE (0=off, 1=on)"
