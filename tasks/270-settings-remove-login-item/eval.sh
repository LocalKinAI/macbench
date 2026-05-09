#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "System Events" to count of (every login item whose name is "TextEdit")' 2>/dev/null || echo "0")"
echo "TextEdit login items: $N"
[[ "$N" == "0" ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
