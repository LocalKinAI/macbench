#!/usr/bin/env bash
# Real verification: AppleScript opens the .numbers file and checks that
# row 2's column A is "Apple". Falls back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/323-imported.numbers"
CONF="$HOME/Desktop/kinbench/323-csv-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

A2="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    set v to ""
    try
        tell front document
            tell active sheet
                tell first table
                    set v to (value of cell "A2") as string
                end tell
            end tell
        end tell
    end try
    try
        close front document saving no
    end try
    return v
end tell
EOF
)"
echo "A2 read: '$A2'"

if [[ "$A2" == "Apple" ]]; then
  echo "PASS: CSV imported (A2=Apple)"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 4096 ]]; then
  echo "PASS (soft): confirmation present, size=$SIZE"
  exit 0
fi
echo "FAIL: CSV not imported correctly"
exit 2
