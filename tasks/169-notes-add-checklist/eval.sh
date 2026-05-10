#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Checklist 169")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"

# Accept either:
#  (a) Notes-internal HTML checklist: gtl-todo / todo-list / class="checkbox"
#  (b) Markdown-style checklist: 3 or more "- [ ]" or "- [x]" items (Notes preserves
#      markdown list syntax in the body when typed as text)
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>/ /g; s/&nbsp;/ /g')"

if printf '%s' "$B" | grep -qiE 'gtl-todo|todo-list|input.*checkbox|class="checkbox"'; then
  echo "PASS: native Notes checklist markup"; exit 0
fi

# count distinct "- [ ]" or "- [x]" markers in plain text
n=$(printf '%s' "$PLAIN" | grep -oE '\- \[[ xX]\]' | wc -l | tr -d ' ')
if [[ "$n" -ge 3 ]]; then
  echo "PASS: $n markdown-style checklist items"; exit 0
fi
echo "FAIL: no checklist markup found (native or markdown); got n=$n"
exit 1
