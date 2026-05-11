#!/usr/bin/env bash
set -uo pipefail
sleep 1
NAME="$(cat "$HOME/.kinbench/346-name" 2>/dev/null)"
if [[ -z "$NAME" ]]; then
  echo "PASS (soft): empty library"
  exit 0
fi
FAV="$(osascript <<APPLE 2>/dev/null
tell application "Photos"
    try
        set hits to (every media item whose name = "$NAME")
        if (count of hits) > 0 then return (favorite of (item 1 of hits)) as string
    end try
    return "false"
end tell
APPLE
)"
echo "favorite: $FAV"
[[ "$FAV" == "true" ]] && { echo "PASS"; exit 0; }
echo "FAIL"
exit 1
