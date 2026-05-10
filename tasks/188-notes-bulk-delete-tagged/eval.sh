#!/usr/bin/env bash
set -uo pipefail
sleep 1
# macOS Notes "delete" moves notes to "Recently Deleted" — names remain
# queryable. Real check: count matches OUTSIDE Recently Deleted.
N="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    set total to 0
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is not "Recently Deleted" then
                    set total to total + (count of (every note of f whose name starts with "KinBench Archive Test"))
                end if
            end repeat
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "remaining matches outside Recently Deleted: $N"
[[ "${N:-1}" == "0" ]] && { echo "PASS: all 3 notes removed"; exit 0; } || { echo "FAIL: $N notes still in active folders"; exit 1; }
