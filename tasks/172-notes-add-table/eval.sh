#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Table 172")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.400s' "$B")"

# Native Notes table markup (HTML body)
if printf '%s' "$B" | grep -qiE '<table|class="table-cell"|class="td"|<tr|<td'; then
  echo "PASS: native Notes table markup"; exit 0
fi

# Markdown-style table — typed as plain text. Look for at least 3 rows of pipe-delimited cells.
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>/\n/g; s/&nbsp;/ /g')"
rows=$(printf '%s\n' "$PLAIN" | grep -cE '^[[:space:]]*\|.*\|[[:space:]]*$' || true)
echo "markdown pipe rows: $rows"
if [[ "${rows:-0}" -ge 2 ]]; then
  echo "PASS: markdown-style table ($rows pipe rows)"; exit 0
fi
echo "FAIL: no table markup"
exit 1
