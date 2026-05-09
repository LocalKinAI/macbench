#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    try
        return count of (every reminder of (first list whose name = "kinbench-imported"))
    on error
        return 0
    end try
end tell
APPLE
)"
echo "reminders in kinbench-imported: $N"
[[ "$N" -ge 3 ]] && { echo "PASS"; exit 0; } || { echo "FAIL: expected ≥3"; exit 1; }
