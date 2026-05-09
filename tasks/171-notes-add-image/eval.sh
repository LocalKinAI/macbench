#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Image 171")
    if (count of ms) = 0 then return "0"
    try
        return (count of attachments of (item 1 of ms)) as string
    on error
        return "0"
    end try
end tell
APPLE
)"
echo "attachments: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
