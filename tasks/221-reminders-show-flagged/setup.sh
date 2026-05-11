#!/usr/bin/env bash
# 221-reminders-show-flagged setup
#
# Plants one flagged reminder so the Flagged smart list is non-empty, and
# clears the agent-side confirmation file.
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/221-flagged-confirm.txt"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Flagged 221")
                delete r
            end repeat
        end try
    end repeat
    tell default list
        set newR to make new reminder with properties {name:"KinBench Flagged 221"}
        try
            set flagged of newR to true
        end try
    end tell
end tell
APPLE
echo "→ planted flagged reminder 'KinBench Flagged 221'"
