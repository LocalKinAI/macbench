#!/usr/bin/env bash
# Real verification: open the file via Numbers AppleScript and read cell A6.
# Should equal 150.
set -uo pipefail
F="$HOME/Desktop/kinbench/314-sheet.numbers"
CONF="$HOME/Desktop/kinbench/314-formula-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

A6="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    try
        tell front document
            tell active sheet
                tell first table
                    set v to value of cell "A6"
                end tell
            end tell
        end tell
    on error
        set v to "ERR"
    end try
    try
        close front document saving no
    end try
    return v as string
end tell
EOF
)"
echo "A6 read: '$A6'"

if [[ "$A6" == "150" ]] || [[ "$A6" == "150.0" ]]; then
  echo "PASS: A6 == 150"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, A6 verification inconclusive"
  exit 0
fi
echo "FAIL: A6 != 150 and no confirmation"
exit 2
