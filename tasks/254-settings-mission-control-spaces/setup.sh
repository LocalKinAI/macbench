#!/usr/bin/env bash
# Snapshot Space count from spaces plist.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PLIST="$HOME/Library/Preferences/com.apple.spaces.plist"
COUNT="$(defaults read com.apple.spaces SpacesDisplayConfiguration 2>/dev/null | grep -c 'ManagedSpaceID' || echo 1)"
[[ -z "$COUNT" || "$COUNT" == "0" ]] && COUNT=1
echo "$COUNT" > "$HOME/.kinbench/254-pre-spaces"
echo "→ pre-space-count: $COUNT"
