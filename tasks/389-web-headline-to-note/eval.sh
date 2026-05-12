#!/usr/bin/env bash
# Pass: the H1 file exists AND a Notes entry titled "KinBench Web 389" exists
# whose body contains "Example Domain".
set -uo pipefail
F="$HOME/Desktop/kinbench/389-h1.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
grep -qi "Example Domain" "$F" || { echo "FAIL: h1 file doesn't contain Example Domain"; exit 2; }

sleep 1
BODY="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    repeat with acct in accounts
        repeat with f in folders of acct
            try
                repeat with n in (every note of f whose name is "KinBench Web 389")
                    return body of n
                end repeat
            end try
        end repeat
    end repeat
    return ""
end tell
APPLE
)"
echo "note body: $BODY"
if printf '%s' "$BODY" | grep -qi "Example Domain"; then
  echo "PASS: H1 saved + note created with body"
  exit 0
fi
echo "FAIL: note missing or body lacks Example Domain"
exit 3
