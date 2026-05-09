#!/usr/bin/env bash
set -uo pipefail
sleep 1
COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Buy Milk"))
        end try
    end repeat
    return total
end tell
EOF
)"
echo "matching reminders: $COUNT"
if [[ "$COUNT" -ge 1 ]] 2>/dev/null; then
  echo "PASS"
  exit 0
fi
echo "FAIL: no matching reminder created"
exit 1
