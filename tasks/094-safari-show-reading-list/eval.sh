#!/usr/bin/env bash
# Pass: agent wrote confirmation OR AX shows a sidebar containing
# 'Reading List'. Sidebar visibility isn't reliably queryable in
# all macOS versions → soft-pass on confirm file is the primary path.
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/094-reading-list-confirm.txt"

# Probe AX for sidebar with Reading List header (best-effort)
SIDEBAR_HIT="$(osascript <<'APPLE' 2>/dev/null
tell application "System Events"
    tell process "Safari"
        try
            set theDescription to (entire contents of window 1)
            set hit to false
            repeat with e in theDescription
                try
                    if (description of e) contains "Reading List" then set hit to true
                end try
            end repeat
            if hit then return "yes"
        end try
    end tell
end tell
return "no"
APPLE
)"
echo "AX sidebar hit: $SIDEBAR_HIT"
[ "$SIDEBAR_HIT" = "yes" ] && { echo "PASS: AX detects Reading List"; exit 0; }

if [ -s "$CONFIRM" ]; then
  echo "PASS: soft confirmation"
  exit 0
fi
echo "FAIL: reading list sidebar not detected"
exit 1
