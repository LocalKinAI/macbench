#!/usr/bin/env bash
# Pass: front document URL is a google search containing the query
# (relaxed match — agent may URL-encode 'computer use' differently).
set -uo pipefail

URL="$(osascript <<'EOF' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    return URL of front document
end tell
EOF
)"

echo "front URL: $URL"
if [[ -z "$URL" ]]; then
  echo "FAIL: Safari not running or no front document"
  exit 1
fi
if [[ "$URL" != *"google."* ]]; then
  echo "FAIL: URL doesn't look like a Google search"
  exit 2
fi
# Decoded the URL to lowercase so '%20' / '+' etc don't matter.
DECODED="$(printf '%s' "$URL" | python3 -c 'import sys,urllib.parse; print(urllib.parse.unquote(sys.stdin.read()).lower())' 2>/dev/null || printf '%s' "$URL" | tr '[:upper:]' '[:lower:]')"
if [[ "$DECODED" != *"macos"* ]] || [[ "$DECODED" != *"benchmark"* ]]; then
  echo "FAIL: search query terms 'macos' + 'benchmark' not found in URL"
  exit 3
fi
echo "PASS: Google search performed with macOS + benchmark in query"
exit 0
