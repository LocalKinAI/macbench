#!/usr/bin/env bash
# 231-reminders-set-recurring eval
#
# AppleScript dict has no recurrence property in Reminders.
# Proxy: reminder exists AND Reminders storage grew (recurrence rule was saved)
# OR body marker mentions weekly.
set -uo pipefail
sleep 1

SANDBOX="$HOME/Desktop/kinbench"
BASELINE_FILE="$SANDBOX/231-baseline.txt"

EXISTS="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Recurring 231"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "exists count: $EXISTS"
if [[ "${EXISTS:-0}" -lt 1 ]] 2>/dev/null; then
  echo "FAIL: reminder 'KinBench Recurring 231' missing"
  exit 1
fi

SIZE_BEFORE=0
[[ -f "$BASELINE_FILE" ]] && SIZE_BEFORE="$(/bin/cat "$BASELINE_FILE")"
SIZE_AFTER="$(/usr/bin/du -sk "$HOME/Library/Reminders" 2>/dev/null | /usr/bin/awk '{print $1}')"
[ -z "$SIZE_AFTER" ] && SIZE_AFTER=0
echo "reminders storage: before=${SIZE_BEFORE}k after=${SIZE_AFTER}k"

if [[ "${SIZE_AFTER:-0}" -gt "${SIZE_BEFORE:-0}" ]] 2>/dev/null; then
  echo "PASS: storage grew — recurrence rule saved"
  exit 0
fi

BODY="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Recurring 231")
            repeat with r in rs
                try
                    return body of r
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
if printf '%s' "$BODY" | /usr/bin/grep -qi 'weekly\|repeat'; then
  echo "PASS: body contains recurrence marker"
  exit 0
fi

echo "FAIL: no evidence of recurrence (storage unchanged, body has no marker)"
exit 2
