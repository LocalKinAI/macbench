#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Heading 174")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"
if printf '%s' "$B" | grep -qiE '<h[12]|font-size:\s*[1-9][0-9]|font-weight:\s*bold.*font-size'; then
  echo "PASS: heading-like style"; exit 0
fi
echo "FAIL: no heading markup"
exit 1
