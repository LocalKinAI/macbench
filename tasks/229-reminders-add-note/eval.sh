#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Description 229")
            repeat with r in rs
                try
                    return body of r
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "body: '$B'"
if printf '%s' "$B" | grep -q "KinBench Notes 229"; then
  echo "PASS"; exit 0
fi
echo "FAIL: body missing 'KinBench Notes 229'"
exit 1
