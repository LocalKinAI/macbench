#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Priority 219")
                delete r
            end repeat
        end try
    end repeat
end tell
APPLE
