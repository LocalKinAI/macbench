#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null | tr -d '[:space:]"' || echo "")"
echo "post FXPreferredViewStyle: $POST"
case "$POST" in
  glyv) echo "PASS: switched to Gallery view (macOS 11+ glyv)"; exit 0 ;;
  Flwv) echo "PASS: switched to CoverFlow view (legacy Flwv)"; exit 0 ;;
  *)    echo "FAIL: expected glyv|Flwv, got '$POST'"; exit 1 ;;
esac
