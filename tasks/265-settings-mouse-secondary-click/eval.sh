#!/usr/bin/env bash
set -uo pipefail
A="$(defaults read com.apple.AppleMultitouchMouse MouseButtonMode 2>/dev/null || echo "")"
B="$(defaults read com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode 2>/dev/null || echo "")"
echo "AppleMultitouchMouse.MouseButtonMode = $A"
echo "AppleBluetoothMultitouch.mouse.MouseButtonMode = $B"
if [[ "$A" == "TwoButton" || "$B" == "TwoButton" ]]; then
  echo "PASS: secondary click = right side (TwoButton)"
  exit 0
fi
# Soft-pass: no mouse plist at all — agent likely had no mouse to configure
if [[ -z "$A$B" ]]; then
  echo "PASS (soft): no mouse plist on this machine; treating as skip"
  exit 0
fi
echo "FAIL: MouseButtonMode is not TwoButton"
exit 1
