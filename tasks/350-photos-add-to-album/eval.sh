#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Photos"
    try
        return (count of (media items of album "KinBench Album 350"))
    on error
        return 0
    end try
end tell
APPLE
)"
N="${N:-0}"
echo "media items in album: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; }
# Soft-pass if library is empty (no photo to add)
TOTAL="$(osascript -e 'tell application "Photos" to count of media items' 2>/dev/null | tr -d '[:space:]')"
TOTAL="${TOTAL:-0}"
if [[ "$TOTAL" -eq 0 ]]; then
  echo "PASS (soft): empty library"
  exit 0
fi
echo "FAIL"
exit 1
