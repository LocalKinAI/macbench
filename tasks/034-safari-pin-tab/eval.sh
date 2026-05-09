#!/usr/bin/env bash
# Safari's AppleScript dictionary doesn't expose `pinned` as a
# tab property in all versions. Fallback: pinned tabs render in
# a separate spot at the leading edge of the tab bar — but UI
# isn't queryable cleanly. Best signal: pinned tabs persist
# across Safari restarts, stored in a plist. Pragma: just check
# the front-window-tab-count went DOWN (from 1 to 0 main + 1
# pinned) OR Safari has a pinned tab in its preferences plist.
set -uo pipefail

# Path varies; try both classic and sandboxed locations.
PINNED_LIST=""
for plist in \
  "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/PinnedTabs.plist" \
  "$HOME/Library/Safari/PinnedTabs.plist"; do
  if [[ -f "$plist" ]]; then
    PINNED_LIST="$(plutil -convert xml1 -o - "$plist" 2>/dev/null || true)"
    break
  fi
done

if printf '%s' "$PINNED_LIST" | grep -qi "apple.com"; then
  echo "PASS: apple.com found in PinnedTabs plist"
  exit 0
fi

# Soft fallback: ask Safari for pinned tabs via dictionary.
PINNED_COUNT="$(osascript <<'EOF' 2>/dev/null
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
EOF
)"
echo "AppleScript pinned count: $PINNED_COUNT"
if [[ "$PINNED_COUNT" -ge 1 ]]; then
  echo "PASS: Safari reports a pinned tab"
  exit 0
fi

echo "FAIL: no pinned tab detected in plist or AppleScript"
exit 1
