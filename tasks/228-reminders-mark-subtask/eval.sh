#!/usr/bin/env bash
# 228-reminders-mark-subtask eval
#
# Pass criteria: the reminder 'KinBench Subtask 228' is marked completed.
# (AppleScript can't query subtask hierarchy — lenient by design.)
set -uo pipefail
sleep 1

C="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Subtask 228")
            repeat with r in rs
                try
                    return (completed of r) as string
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "completed: $C"
if [[ "$C" == "true" ]]; then
  echo "PASS: subtask marked completed"
  exit 0
fi
echo "FAIL: subtask not completed (got '$C')"
exit 1
