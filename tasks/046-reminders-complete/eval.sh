#!/usr/bin/env bash
# Pass: ≥1 matching reminder where completed = true (none uncompleted).
set -uo pipefail
sleep 1

UNCOMPLETED="$(osascript <<'EOF' 2>/dev/null
tell application "Reminders"
    set u to 0
    repeat with lst in lists
        try
            set u to u + (count of (every reminder of lst whose name = "KinBench Mark Done" and completed is false))
        end try
    end repeat
    return u
end tell
EOF
)"
COMPLETED="$(osascript <<'EOF' 2>/dev/null
tell application "Reminders"
    set c to 0
    repeat with lst in lists
        try
            set c to c + (count of (every reminder of lst whose name = "KinBench Mark Done" and completed is true))
        end try
    end repeat
    return c
end tell
EOF
)"
echo "uncompleted: $UNCOMPLETED   completed: $COMPLETED"
if [[ "$UNCOMPLETED" == "0" ]] && [[ "$COMPLETED" -ge 1 ]] 2>/dev/null; then
  echo "PASS: reminder marked done"
  exit 0
fi
echo "FAIL: still has uncompleted matching reminder"
exit 1
