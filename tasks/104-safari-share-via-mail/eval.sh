#!/usr/bin/env bash
# Pass: there's a Mail draft whose subject starts with "KinBench Share 104".
set -uo pipefail
sleep 1
COUNT="$(osascript <<'APPLE' 2>/dev/null
tell application "Mail"
    set total to 0
    try
        repeat with acct in accounts
            try
                set total to total + (count of (every message of (mailbox "Drafts" of acct) whose subject starts with "KinBench Share 104"))
            end try
        end repeat
    end try
    return total as string
end tell
APPLE
)"
echo "matching drafts: $COUNT"
if [ -n "$COUNT" ] && [ "$COUNT" -ge 1 ] 2>/dev/null; then
  echo "PASS: at least one matching share draft exists"
  exit 0
fi
echo "FAIL: no Mail draft with subject 'KinBench Share 104'"
exit 1
