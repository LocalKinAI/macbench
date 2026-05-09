#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.finder ShowPathbar 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "post ShowPathbar: $POST"
case "$POST" in
  1|true|TRUE|YES) echo "PASS: ShowPathbar toggled on"; exit 0 ;;
  *) echo "FAIL: expected 1/true, got '$POST'"; exit 1 ;;
esac
