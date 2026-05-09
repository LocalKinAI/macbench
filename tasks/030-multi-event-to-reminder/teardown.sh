#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Source Event")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
end tell
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Source Event")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
end tell
EOF
