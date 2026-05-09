#!/usr/bin/env bash
# Pass: ≥1 Reminder named "KinBench Source Event".
set -uo pipefail
sleep 1

COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Source Event"))
        end try
    end repeat
    return total
end tell
EOF
)"

echo "matching reminders: $COUNT"

if [[ -z "$COUNT" ]]; then
  echo "FAIL: AppleScript query failed (Reminders not granted Automation?)"
  exit 1
fi
if [[ "$COUNT" -ge 1 ]]; then
  echo "PASS: reminder created"
  exit 0
fi
echo "FAIL: no matching reminder"
exit 2
