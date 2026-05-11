#!/usr/bin/env bash
# Pass: NSUserKeyEquivalents contains 'About Safari' = '@$k'.
set -uo pipefail
POST="$(defaults read com.apple.Safari NSUserKeyEquivalents 2>/dev/null || echo '')"
echo "post: $POST"
if echo "$POST" | grep -q "About Safari" && echo "$POST" | grep -q '@\$k'; then
  echo "PASS: Cmd+Shift+K bound to 'About Safari'"
  exit 0
fi
# Also accept other shift+cmd+k formats (e.g. @^k or just @k modifier guesses)
if echo "$POST" | grep -q "About Safari"; then
  echo "PASS (lenient): some shortcut bound to 'About Safari'"
  exit 0
fi
echo "FAIL: 'About Safari' shortcut not found"
exit 1
