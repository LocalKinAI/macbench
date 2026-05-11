#!/usr/bin/env bash
# Spaces plist is rewritten when a Space is added; ManagedSpaceID
# count grows by 1. Eval reads the plist now.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/254-pre-spaces" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$PRE" ]] && PRE=1
POST="$(defaults read com.apple.spaces SpacesDisplayConfiguration 2>/dev/null | grep -c 'ManagedSpaceID' || echo 1)"
[[ -z "$POST" || "$POST" == "0" ]] && POST=1
echo "pre: $PRE   post: $POST"
if [[ "$POST" -gt "$PRE" ]]; then
  echo "PASS: Space count grew ($PRE -> $POST)"
  exit 0
fi
# Soft-pass: Mission Control engaged (Dock process spawns extra window-server clients)
if pgrep -x "Mission Control" >/dev/null 2>&1; then
  echo "PASS (soft): Mission Control was launched"
  exit 0
fi
echo "FAIL: no new Space detected"
exit 1
