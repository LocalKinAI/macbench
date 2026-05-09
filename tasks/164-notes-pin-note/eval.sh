#!/usr/bin/env bash
set -uo pipefail
sleep 1
P="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Pinned 164")
    if (count of ms) = 0 then return ""
    try
        return (pinned of (item 1 of ms)) as string
    on error
        return "?"
    end try
end tell
APPLE
)"
echo "pinned: '$P'"
[[ "$P" == "true" ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
