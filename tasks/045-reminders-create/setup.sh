#!/usr/bin/env bash
set -uo pipefail
osascript <<'EOF' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            set toDel to (every reminder of lst whose name = "KinBench Buy Milk")
            repeat with r in toDel
                delete r
            end repeat
        end try
    end repeat
end tell
EOF
echo "→ cleared prior KinBench Buy Milk reminders"
