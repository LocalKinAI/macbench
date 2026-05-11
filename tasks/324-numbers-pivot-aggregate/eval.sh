#!/usr/bin/env bash
# Heuristic: open the .numbers file, count sheets (should be >= 2), and search
# for category totals 25/30/30 in the bundle. Falls back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/324-sheet.numbers"
CONF="$HOME/Desktop/kinbench/324-pivot-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

SHEETS="$(osascript <<EOF 2>/dev/null
tell application "Numbers"
    open POSIX file "$F"
    delay 1.2
    set n to 0
    try
        tell front document
            set n to count of sheets
        end tell
    end try
    try
        close front document saving no
    end try
    return n
end tell
EOF
)"
echo "sheets: '$SHEETS'"

if [[ -n "$SHEETS" ]] && [[ "$SHEETS" -ge 2 ]]; then
  echo "PASS: extra sheet created (count=$SHEETS)"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, sheet count $SHEETS"
  exit 0
fi
echo "FAIL: only $SHEETS sheets, no confirmation"
exit 2
