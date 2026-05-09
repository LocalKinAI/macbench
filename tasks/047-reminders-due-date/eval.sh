#!/usr/bin/env bash
# Pass: matching reminder has due date and the date string contains
# "5:00 PM" or "17:00" + tomorrow's date hint.
set -uo pipefail
sleep 1

DUE="$(osascript <<'EOF' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Schedule")
            repeat with r in rs
                try
                    return (due date of r) as string
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
EOF
)"

echo "due date: $DUE"
if [[ -z "$DUE" ]]; then
  echo "FAIL: reminder has no due date"
  exit 1
fi
if [[ "$DUE" == *"5:00:00 PM"* ]] || [[ "$DUE" == *"17:00"* ]] || [[ "$DUE" == *"5:00 PM"* ]]; then
  echo "PASS: due date set to ~5 PM"
  exit 0
fi
echo "FAIL: due date doesn't include 5:00 PM / 17:00"
exit 2
