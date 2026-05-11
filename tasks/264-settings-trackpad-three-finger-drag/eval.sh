#!/usr/bin/env bash
set -uo pipefail
A="$(defaults read com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag 2>/dev/null || echo "0")"
B="$(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag 2>/dev/null || echo "0")"
echo "AppleMultitouchTrackpad.TrackpadThreeFingerDrag = $A"
echo "AppleBluetoothMultitouch.trackpad.TrackpadThreeFingerDrag = $B"
if [[ "$A" == "1" || "$B" == "1" ]]; then
  echo "PASS: three-finger drag enabled"
  exit 0
fi
echo "FAIL: three-finger drag not enabled"
exit 1
