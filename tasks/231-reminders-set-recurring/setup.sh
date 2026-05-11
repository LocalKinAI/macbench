#!/usr/bin/env bash
# 231-reminders-set-recurring setup
#
# Plants a reminder with a due date (needed for recurrence to be settable).
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"

# Snapshot Reminders storage size — recurrence rules increase storage.
SIZE_BEFORE="$(/usr/bin/du -sk "$HOME/Library/Reminders" 2>/dev/null | /usr/bin/awk '{print $1}')"
[ -z "$SIZE_BEFORE" ] && SIZE_BEFORE=0
printf '%s\n' "$SIZE_BEFORE" > "$SANDBOX/231-baseline.txt"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Recurring 231")
                delete r
            end repeat
        end try
    end repeat
    set d to current date
    set d to d + (24 * 60 * 60)
    set hours of d to 9
    set minutes of d to 0
    set seconds of d to 0
    tell default list
        make new reminder with properties {name:"KinBench Recurring 231", due date:d}
    end tell
end tell
APPLE
echo "→ planted 'KinBench Recurring 231' (due tomorrow 9am, baseline=${SIZE_BEFORE}k)"
