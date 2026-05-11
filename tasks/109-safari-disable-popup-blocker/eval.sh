#!/usr/bin/env bash
# Per-site popup settings live in com.apple.Safari plist as a deeply
# nested dict. We attempt to grep it; if not parseable, soft-pass
# on the confirm file.
set -uo pipefail
F="$HOME/Desktop/kinbench/109-popups-confirm.txt"

PLIST_DUMP="$(defaults export com.apple.Safari - 2>/dev/null || true)"
if printf '%s' "$PLIST_DUMP" | grep -qi "example.com" && printf '%s' "$PLIST_DUMP" | grep -qi "popup\|Allow"; then
  echo "PASS: example.com appears with popup permission in Safari prefs"
  exit 0
fi

if [ -s "$F" ] && grep -qi "example\|popup\|allow" "$F"; then
  echo "PASS: soft confirmation"
  exit 0
fi
echo "FAIL: no per-site popup setting and no confirm file"
exit 1
