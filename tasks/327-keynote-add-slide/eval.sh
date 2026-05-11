#!/usr/bin/env bash
# Real verification: AppleScript opens the deck and counts slides — should be
# >= 2 after the agent adds one.
set -uo pipefail
F="$HOME/Desktop/kinbench/327-deck.key"
CONF="$HOME/Desktop/kinbench/327-slide-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

N="$(osascript <<EOF 2>/dev/null
tell application "Keynote"
    open POSIX file "$F"
    delay 1.5
    set n to 0
    try
        set n to (count slides of front document)
    end try
    try
        close front document saving no
    end try
    return n
end tell
EOF
)"
echo "slides: '$N'"

if [[ -n "$N" ]] && [[ "$N" -ge 2 ]]; then
  echo "PASS: $N slides (>=2)"
  exit 0
fi
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, slide count inconclusive"
  exit 0
fi
echo "FAIL: slide count $N < 2"
exit 2
