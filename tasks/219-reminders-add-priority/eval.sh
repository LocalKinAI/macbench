#!/usr/bin/env bash
set -uo pipefail
sleep 1
P="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Priority 219")
            repeat with r in rs
                return (priority of r) as string
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "priority: $P"
[[ "$P" == "1" ]] && { echo "PASS: priority is High (1)"; exit 0; }
echo "FAIL: priority not High (got '$P')"
exit 1
