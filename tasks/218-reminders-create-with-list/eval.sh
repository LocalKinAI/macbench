#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    try
        return count of (every reminder of (first list whose name = "kinbench-list-218") whose name = "KinBench List Item 218")
    on error
        return 0
    end try
end tell
APPLE
)"
echo "matching: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
