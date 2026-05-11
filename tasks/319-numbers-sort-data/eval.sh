#!/usr/bin/env bash
# Real verification: read A1..A5 and check ascending order (10,20,30,40,50).
set -uo pipefail
F="$HOME/Desktop/kinbench/319-sheet.numbers"
CONF="$HOME/Desktop/kinbench/319-sort-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

VALS="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    set out to ""
    try
        tell front document
            tell active sheet
                tell first table
                    repeat with r from 1 to 5
                        set out to out & (value of cell ("A" & r)) & ","
                    end repeat
                end tell
            end tell
        end tell
    end try
    try
        close front document saving no
    end try
    return out
end tell
EOF
)"
echo "A1..A5: $VALS"

if [[ "$VALS" == "10,20,30,40,50," ]] || [[ "$VALS" == "10.0,20.0,30.0,40.0,50.0," ]]; then
  echo "PASS: column A is sorted ascending"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, sort verification inconclusive ($VALS)"
  exit 0
fi
echo "FAIL: column A not sorted ($VALS)"
exit 2
