#!/usr/bin/env bash
osascript -e 'tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Flag 220")
                delete r
            end repeat
        end try
    end repeat
end tell' 2>/dev/null || true
