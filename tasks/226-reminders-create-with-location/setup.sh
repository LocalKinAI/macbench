#!/usr/bin/env bash
# 226-reminders-create-with-location setup
#
# Clears any prior KinBench Location 226 reminders.
set -uo pipefail

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Location 226")
                delete r
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ cleared prior 'KinBench Location 226' reminders"
