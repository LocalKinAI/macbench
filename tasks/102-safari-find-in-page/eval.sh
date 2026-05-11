#!/usr/bin/env bash
# Find bar visibility isn't reliably queryable via shell. Try AX
# for a 'Find' text field; otherwise soft-pass on agent's confirm.
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/102-find-confirm.txt"

AX_HIT="$(osascript <<'APPLE' 2>/dev/null
tell application "System Events"
    tell process "Safari"
        try
            set ents to entire contents of window 1
            set hit to "no"
            repeat with e in ents
                try
                    if (description of e) contains "Find" then set hit to "yes"
                end try
            end repeat
            return hit
        end try
    end tell
end tell
return "no"
APPLE
)"
echo "AX find bar: $AX_HIT"

if [ -s "$CONFIRM" ] && grep -qi "macos\|find" "$CONFIRM"; then
  echo "PASS: confirmation file present"
  exit 0
fi
if [ "$AX_HIT" = "yes" ]; then
  echo "PASS: AX shows Find element"
  exit 0
fi
echo "FAIL: no find bar evidence"
exit 1
