#!/usr/bin/env bash
# Pass: ≥1 note named "KinBench Test 014" whose body contains the
# required substring. Notes' body field returns HTML — strip tags
# before substring check.
set -uo pipefail

# Notes can take a beat to settle a brand-new note's body content.
sleep 1

BODY="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    set matches to (every note whose name = "KinBench Test 014")
    if (count of matches) = 0 then return ""
    return body of (item 1 of matches)
end tell
EOF
)"

if [[ -z "$BODY" ]]; then
  echo "FAIL: no note titled 'KinBench Test 014' found"
  exit 1
fi

# Strip HTML tags + entity-decode &nbsp; for substring match.
PLAIN="$(printf '%s' "$BODY" | sed 's/<[^>]*>//g; s/\&nbsp;/ /g')"
echo "body (plain): $(printf '%.200s' "$PLAIN")"

if printf '%s' "$PLAIN" | grep -q "agent benchmark validation"; then
  echo "PASS: note created with required body content"
  exit 0
fi
echo "FAIL: body doesn't contain 'agent benchmark validation'"
exit 2
