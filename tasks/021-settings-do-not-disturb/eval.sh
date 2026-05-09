#!/usr/bin/env bash
# macOS Focus mode active state is stored in
#   ~/Library/DoNotDisturb/DB/Assertions.json
# (when Focus is active there's a non-empty assertion). Path may vary
# by macOS version; we also check via AppleScript as a fallback.
set -uo pipefail

ASSERT="$HOME/Library/DoNotDisturb/DB/Assertions.json"
if [[ -f "$ASSERT" ]]; then
  if grep -q '"Assertions"\s*:\s*\[\s*{' "$ASSERT" 2>/dev/null; then
    echo "PASS: active assertion in $ASSERT"
    exit 0
  fi
fi

# Fallback: ask System Events whether DnD is on. Some macOS versions
# expose this; if not, AppleScript returns missing value.
DND_ON="$(osascript -e 'tell application "System Events" to return (do not disturb of (first process whose frontmost is true)) as string' 2>/dev/null || echo "")"
if [[ "$DND_ON" == "true" ]]; then
  echo "PASS: System Events reports Do Not Disturb on"
  exit 0
fi

echo "FAIL: no active Focus assertion detected"
echo "(this task may be eval-flaky on certain macOS versions; see"
echo " tests/bench/AUTHOR_GUIDE.md for the limitation)"
exit 1
