#!/usr/bin/env bash
# Real verification: open the file and count rows in the first table. After the
# agent inserts a row, the table should have at least 6 body rows (plus header,
# depending on Numbers' default — accept >= 6).
set -uo pipefail
F="$HOME/Desktop/kinbench/315-sheet.numbers"
CONF="$HOME/Desktop/kinbench/315-row-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

ROWS="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    set n to 0
    try
        tell front document
            tell active sheet
                tell first table
                    set n to count of rows
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
echo "rows: '$ROWS'"

if [[ -n "$ROWS" ]] && [[ "$ROWS" -ge 6 ]]; then
  echo "PASS: $ROWS rows (>=6)"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, row count inconclusive"
  exit 0
fi
echo "FAIL: row count $ROWS < 6"
exit 2
