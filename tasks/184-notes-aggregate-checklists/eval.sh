#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Aggregate 184")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
if [[ -z "$B" ]]; then
  echo "FAIL: aggregate note 'KinBench Aggregate 184' missing"
  exit 1
fi
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "aggregate body plain: $(printf '%.500s' "$PLAIN")"

required=("alpha-done-one" "alpha-done-two" "bravo-done-only")
forbidden=("alpha-pending-one" "bravo-pending-one" "charlie-pending-one" "charlie-pending-two")

missing=0
for r in "${required[@]}"; do
  if ! printf '%s' "$PLAIN" | grep -q "$r"; then
    echo "  missing required: $r"
    missing=$((missing+1))
  fi
done

leaked=0
for f in "${forbidden[@]}"; do
  if printf '%s' "$PLAIN" | grep -q "$f"; then
    echo "  leaked pending item: $f"
    leaked=$((leaked+1))
  fi
done

if [[ $missing -eq 0 && $leaked -eq 0 ]]; then
  echo "PASS: all 3 done items present, no pending items leaked"
  exit 0
fi
echo "FAIL: missing=$missing leaked=$leaked"
exit 1
