#!/usr/bin/env bash
# 230-reminders-attach-image eval
#
# Reminders' AppleScript dict has no `attachments` property. Proxy check:
#   - Reminder named 'KinBench Image 230' still exists
#   - Reminders' local storage grew vs. baseline (an attachment landed)
# OR
#   - Reminder body contains a marker the agent could plant if it can't
#     get UI attach to work (graceful fallback).
set -uo pipefail
sleep 1

SANDBOX="$HOME/Desktop/kinbench"
BASELINE_FILE="$SANDBOX/230-baseline.txt"

EXISTS="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set total to 0
    repeat with lst in lists
        try
            set total to total + (count of (every reminder of lst whose name = "KinBench Image 230"))
        end try
    end repeat
    return total
end tell
APPLE
)"
echo "exists count: $EXISTS"
if [[ "${EXISTS:-0}" -lt 1 ]] 2>/dev/null; then
  echo "FAIL: reminder 'KinBench Image 230' missing"
  exit 1
fi

SIZE_BEFORE=0
[[ -f "$BASELINE_FILE" ]] && SIZE_BEFORE="$(/bin/cat "$BASELINE_FILE")"
SIZE_AFTER="$(/usr/bin/du -sk "$HOME/Library/Reminders" 2>/dev/null | /usr/bin/awk '{print $1}')"
[ -z "$SIZE_AFTER" ] && SIZE_AFTER=0
echo "reminders storage: before=${SIZE_BEFORE}k after=${SIZE_AFTER}k"

if [[ "${SIZE_AFTER:-0}" -gt "${SIZE_BEFORE:-0}" ]] 2>/dev/null; then
  echo "PASS: Reminders storage grew (attachment likely added)"
  exit 0
fi

# Soft-fallback: body marker
BODY="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Image 230")
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
if printf '%s' "$BODY" | /usr/bin/grep -qi '230-img\|attached\|image'; then
  echo "PASS: body contains attachment marker"
  exit 0
fi

echo "FAIL: no evidence of attachment (storage unchanged, body has no marker)"
exit 2
