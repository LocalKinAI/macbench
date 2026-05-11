#!/usr/bin/env bash
# 233-reminders-filter-by-tag setup
#
# Plants two reminders with body '#kinbench' so the tag exists, and
# clears the agent-side confirmation file.
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/233-tag-confirm.txt"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name starts with "KinBench Tagged 233")
                delete r
            end repeat
        end try
    end repeat
    tell default list
        make new reminder with properties {name:"KinBench Tagged 233 A", body:"#kinbench"}
        make new reminder with properties {name:"KinBench Tagged 233 B", body:"#kinbench"}
    end tell
end tell
APPLE
echo "→ planted 2 tagged reminders"
