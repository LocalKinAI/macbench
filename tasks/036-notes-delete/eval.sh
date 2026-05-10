#!/usr/bin/env bash
set -uo pipefail
sleep 1
# macOS Notes "delete" moves the note to "Recently Deleted" — its name remains
# in the DB. Real deletion check: count matching notes OUTSIDE Recently Deleted.
COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    set total to 0
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is not "Recently Deleted" then
                    set total to total + (count of (every note of f whose name = "KinBench Test 036 (delete me)"))
                end if
            end repeat
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "matching notes outside Recently Deleted: $COUNT"
if [[ "${COUNT:-1}" == "0" ]]; then
  echo "PASS: note removed from active folders"
  exit 0
fi
echo "FAIL: note still exists in active folders ($COUNT match)"
exit 1
