#!/usr/bin/env bash
set -uo pipefail
sleep 1
F="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Move 176")
    if (count of ms) = 0 then return ""
    try
        return name of (container of (item 1 of ms))
    on error
        return ""
    end try
end tell
APPLE
)"
echo "container: '$F'"
[[ "$F" == "kinbench-folder" ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
