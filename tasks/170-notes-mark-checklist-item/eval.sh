#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Mark 170")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.400s' "$B")"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>/ /g; s/&nbsp;/ /g')"

# Pass conditions (need BOTH a checklist-form AND at least one checked item):
# - Native Notes:    body contains gtl-todo etc, AND a "checked"-flavored attribute
# - Markdown style:  at least one "- [x]" (checked) AND at least one "- [ ]" (unchecked)
has_native_list=0; has_native_checked=0
printf '%s' "$B" | grep -qiE 'gtl-todo|todo-list|input.*checkbox' && has_native_list=1
printf '%s' "$B" | grep -qiE 'checked|class="[^"]*\bcompleted\b|class="[^"]*\bchecked\b' && has_native_checked=1

n_unchecked=$(printf '%s' "$PLAIN" | grep -oE '\- \[ \]' | wc -l | tr -d ' ')
n_checked=$(printf '%s' "$PLAIN"   | grep -oE '\- \[[xX]\]' | wc -l | tr -d ' ')

echo "native_list=$has_native_list  native_checked=$has_native_checked  md_unchecked=$n_unchecked  md_checked=$n_checked"

if [[ $has_native_list -eq 1 && $has_native_checked -eq 1 ]]; then
  echo "PASS: native checklist with checked item"; exit 0
fi
if [[ $n_checked -ge 1 && $n_unchecked -ge 1 ]]; then
  echo "PASS: markdown checklist with $n_checked checked + $n_unchecked unchecked items"; exit 0
fi
echo "FAIL: need a checklist with at least one checked + one unchecked item"
exit 1
