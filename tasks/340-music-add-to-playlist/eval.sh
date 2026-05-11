#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Music"
    try
        return (count of (every track of user playlist "KinBench Mix 340"))
    on error
        return 0
    end try
end tell
APPLE
)"
N="${N:-0}"
echo "tracks in playlist: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
