#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
DIR="$HOME/Library/Application Support/ScreenTimeAgent"
PRE=0
if [[ -d "$DIR" ]]; then
  PRE="$(find "$DIR" -type f -exec stat -f '%m' {} \; 2>/dev/null | sort -rn | head -1)"
fi
[[ -z "$PRE" ]] && PRE=0
echo "$PRE" > "$HOME/.kinbench/262-pre-st"
echo "→ pre-screen-time-latest-mtime: $PRE"
