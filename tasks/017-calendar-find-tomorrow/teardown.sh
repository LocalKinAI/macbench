#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Find Me")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ cleaned up KinBench Find Me events"
