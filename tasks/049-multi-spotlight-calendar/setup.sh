#!/usr/bin/env bash
# Quit Calendar so the agent has to actually use Spotlight to launch it.
set -uo pipefail
osascript -e 'tell application "Calendar" to quit' 2>/dev/null || true
sleep 1

osascript <<'EOF' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Spotlight Path")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ Calendar quit + prior events cleared"
