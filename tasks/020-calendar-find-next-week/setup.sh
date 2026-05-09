#!/usr/bin/env bash
# Plant a "KinBench Weekly Sync" event 3 days from now. Stash the
# expected day name so eval can compare without depending on locale.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX" "$HOME/.kinbench"
rm -f "$SANDBOX/020-day.txt"

EXPECTED_DAY="$(date -v +3d "+%A")"
echo "$EXPECTED_DAY" > "$HOME/.kinbench/020-expected-day"

osascript <<EOF 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            set toDel to (every event of cal whose summary = "KinBench Weekly Sync")
            repeat with ev in toDel
                delete ev
            end repeat
        end try
    end repeat
    set targetDate to (current date) + (3 * days)
    set hours of targetDate to 10
    set minutes of targetDate to 0
    set seconds of targetDate to 0
    set endDate to targetDate + (30 * minutes)
    set targetCal to first calendar
    try
        repeat with c in calendars
            if (writable of c) is true then
                set targetCal to c
                exit repeat
            end if
        end repeat
    end try
    tell targetCal
        make new event with properties {summary:"KinBench Weekly Sync", start date:targetDate, end date:endDate}
    end tell
end tell
EOF

echo "→ planted KinBench Weekly Sync 3 days from now ($EXPECTED_DAY)"
