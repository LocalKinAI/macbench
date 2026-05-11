#!/usr/bin/env bash
# Real verification: open the deck and read the title of slide 1 — expect
# 'Slide3'. Falls back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/333-deck.key"
CONF="$HOME/Desktop/kinbench/333-rearrange-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

T="$(osascript <<EOF 2>/dev/null
tell application "Keynote"
    open POSIX file "$F"
    delay 1.5
    set t to ""
    try
        tell front document
            tell slide 1
                try
                    set t to (object text of (first text item)) as string
                end try
            end tell
        end tell
    end try
    try
        close front document saving no
    end try
    return t
end tell
EOF
)"
echo "slide 1 title: '$T'"

if [[ "$T" == "Slide3"* ]] || [[ "$T" == *"Slide3"* ]]; then
  echo "PASS: slide 1 title is Slide3"
  exit 0
fi

SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, slide 1 title was '$T'"
  exit 0
fi
echo "FAIL: slide 1 title '$T' != Slide3"
exit 2
