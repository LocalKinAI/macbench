#!/usr/bin/env bash
set -uo pipefail
sleep 1
PINNED_LIST=""
for plist in \
  "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/PinnedTabs.plist" \
  "$HOME/Library/Safari/PinnedTabs.plist"; do
  [[ -f "$plist" ]] && PINNED_LIST="$(plutil -convert xml1 -o - "$plist" 2>/dev/null || true)" && break
done
HITS=0
for d in apple.com github.com wikipedia.org; do
  printf '%s' "$PINNED_LIST" | grep -qi "$d" && HITS=$((HITS+1))
done
echo "pinned domain hits: $HITS / 3"
[[ "$HITS" -ge 3 ]] && { echo "PASS"; exit 0; }
# AppleScript fallback
PCOUNT="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    try
        set c to 0
        repeat with t in tabs of front window
            try
                if pinned of t is true then set c to c + 1
            end try
        end repeat
        return c
    on error
        return -1
    end try
end tell
APPLE
)"
echo "AppleScript pinned count: $PCOUNT"
[[ "$PCOUNT" -ge 3 ]] && { echo "PASS (AS fallback)"; exit 0; }
echo "FAIL: <3 pinned tabs detected"
exit 1
