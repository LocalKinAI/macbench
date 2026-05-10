#!/usr/bin/env bash
# Lock state isn't directly queryable via AppleScript on modern macOS.
# Heuristic: when a note is locked from another session, AppleScript can
# still see the note exists by name, but body returns empty/truncated.
# We verify: (a) note still exists, (b) body marker is gone OR
# (c) password-protected property reads true (newer macOS Notes only).
set -uo pipefail
sleep 1

R="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Lock 166")
    if (count of ms) = 0 then return "missing|"
    set m to item 1 of ms
    set bodyTxt to ""
    try
        set bodyTxt to body of m as string
    end try
    set protTxt to "?"
    try
        set protTxt to (password protected of m) as string
    end try
    return protTxt & "|" & bodyTxt
end tell
APPLE
)"

PROT="${R%%|*}"
BODY="${R#*|}"
echo "password_protected: '$PROT'  body_length: ${#BODY}"

if [[ "$PROT" == "missing" ]]; then
  echo "FAIL: note 'KinBench Lock 166' deleted instead of locked"
  exit 1
fi
if [[ "$PROT" == "true" ]]; then
  echo "PASS: password protected = true"
  exit 0
fi
if ! printf '%s' "$BODY" | grep -q "KINBENCH-LOCK-MARKER-166"; then
  echo "PASS: note exists but body marker unreadable (likely locked)"
  exit 0
fi
echo "FAIL: body still readable, lock not applied"
exit 1
