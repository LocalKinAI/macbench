#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(pmset -g 2>/dev/null | awk '/lowpowermode/{print $2; exit}')"
[[ -z "$PRE" ]] && PRE="0"
echo "$PRE" > "$HOME/.kinbench/247-pre-lpm"
echo "→ pre-low-power: $PRE"
