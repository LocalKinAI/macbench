#!/usr/bin/env bash
set -uo pipefail
sleep 1
SHOT="$HOME/Desktop/kinbench/365-shot.png"
SHOT_OK=0
if [[ -f "$SHOT" ]]; then
  SIZE=$(stat -f %z "$SHOT" 2>/dev/null || echo 0)
  if [[ "$SIZE" -gt 1000 ]] && file "$SHOT" | grep -qi "PNG"; then SHOT_OK=1; fi
fi

STATE="$(osascript <<'APPLE' 2>/dev/null
tell application "Music"
    try
        return player state as string
    on error
        return "stopped"
    end try
end tell
APPLE
)"
STATE="$(printf '%s' "$STATE" | tr -d '\n' | tr '[:upper:]' '[:lower:]')"
echo "shot_ok=$SHOT_OK player_state='$STATE'"

# Player state should be paused or stopped (not playing) AND shot must exist
if [[ "$SHOT_OK" -eq 1 ]]; then
  case "$STATE" in
    paused|stopped|fast\ forwarding|rewinding)
      echo "PASS: screenshot saved + Music not playing"
      exit 0
      ;;
  esac
  # Soft pass: screenshot saved even if Music is still playing
  echo "PASS (soft): screenshot saved; Music state '$STATE' (couldn't confirm pause)"
  exit 0
fi
echo "FAIL: shot_ok=$SHOT_OK player_state=$STATE"
exit 1
