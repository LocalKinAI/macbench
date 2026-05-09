#!/usr/bin/env bash
set -uo pipefail
sleep 1
F="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Flag 220")
            repeat with r in rs
                try
                    return (flagged of r) as string
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "flagged: $F"
[[ "$F" == "true" ]] && { echo "PASS"; exit 0; }
echo "FAIL: not flagged"
exit 1
