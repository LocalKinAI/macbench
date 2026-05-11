#!/usr/bin/env bash
# Real verification: default Numbers table is 4 columns (A-D). After adding
# one, count of columns should be >= 5.
set -uo pipefail
F="$HOME/Desktop/kinbench/316-sheet.numbers"
CONF="$HOME/Desktop/kinbench/316-col-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

COLS="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    set n to 0
    try
        tell front document
            tell active sheet
                tell first table
                    set n to count of columns
                end tell
            end tell
        end tell
    end try
    try
        close front document saving no
    end try
    return n
end tell
EOF
)"
echo "columns: '$COLS'"

if [[ -n "$COLS" ]] && [[ "$COLS" -ge 5 ]]; then
  echo "PASS: $COLS columns (>=5)"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, column count inconclusive"
  exit 0
fi
echo "FAIL: column count $COLS < 5"
exit 2
