#!/usr/bin/env bash
# 235-reminders-from-mail eval
#
# Pass criteria: the destination list contains >= 3 reminders whose titles
# each start with 'Please '. Substring match against the three known items
# is bonus (any 2 of 3 keywords across all titles = strong pass).
set -uo pipefail
sleep 1

NAMES="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    set out to ""
    try
        tell list "kinbench-from-mail-235"
            repeat with r in reminders
                set out to out & (name of r) & linefeed
            end repeat
        end tell
    end try
    return out
end tell
APPLE
)"
echo "--- reminders in list ---"
printf '%s' "$NAMES"
echo "-------------------------"

PLEASE_COUNT="$(printf '%s' "$NAMES" | /usr/bin/grep -c '^Please ' || true)"
echo "starts-with-Please count: $PLEASE_COUNT"

if [[ "${PLEASE_COUNT:-0}" -lt 3 ]] 2>/dev/null; then
  echo "FAIL: need >= 3 reminders starting with 'Please ' (got $PLEASE_COUNT)"
  exit 1
fi

# Bonus keyword coverage — at least 2 of the 3 expected concepts present
HITS=0
printf '%s' "$NAMES" | /usr/bin/grep -qi 'budget' && HITS=$((HITS+1))
printf '%s' "$NAMES" | /usr/bin/grep -qi 'offsite\|venue' && HITS=$((HITS+1))
printf '%s' "$NAMES" | /usr/bin/grep -qi 'launch\|checklist\|marketing' && HITS=$((HITS+1))
echo "concept hits: $HITS / 3"

if [[ "$HITS" -ge 2 ]]; then
  echo "PASS: 3+ Please-prefixed reminders w/ matching content"
  exit 0
fi
echo "FAIL: 3 reminders present but content doesn't match action items"
exit 2
