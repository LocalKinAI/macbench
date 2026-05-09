#!/usr/bin/env bash
# Pass: front Finder window's target POSIX path is /tmp (or /private/tmp).
set -uo pipefail
PATH_OUT="$(osascript <<'EOF' 2>/dev/null
tell application "Finder"
    if (count of windows) = 0 then return ""
    return POSIX path of (target of front window as alias)
end tell
EOF
)"
echo "front window path: '$PATH_OUT'"
case "$PATH_OUT" in
  /tmp/|/private/tmp/) echo "PASS: navigated to /tmp"; exit 0 ;;
  *) echo "FAIL: expected /tmp/ or /private/tmp/, got '$PATH_OUT'"; exit 1 ;;
esac
