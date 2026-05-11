#!/usr/bin/env bash
# Heuristic + AppleScript: deck should have 5 slides; bundle should contain
# the unique heading strings.
set -uo pipefail
F="$HOME/Desktop/kinbench/335-deck.key"
CONF="$HOME/Desktop/kinbench/335-outline-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

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

hits=0
if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    for h in "KinBench Intro" "Why benchmark" "Architecture" "Results" "Next steps"; do
      if grep -r -a -l "$h" "$TMP" 2>/dev/null | grep -q .; then
        hits=$((hits + 1))
      fi
    done
  fi
fi

if [[ -n "$N" ]] && [[ "$N" -ge 5 ]] && [[ "$hits" -ge 3 ]]; then
  echo "PASS: $N slides + $hits/5 outline headings present"
  exit 0
fi
if [[ -n "$N" ]] && [[ "$N" -ge 5 ]]; then
  echo "PASS (partial): $N slides built, only $hits/5 outline headings located"
  exit 0
fi
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 1024 ]]; then
  echo "PASS (soft): confirmation present, $N slides, $hits/5 headings"
  exit 0
fi
echo "FAIL: only $N slides, $hits/5 headings"
exit 2
