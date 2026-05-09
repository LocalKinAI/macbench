#!/usr/bin/env bash
# Pass: AppleShowAllFiles is now TRUE (agent flipped it).
set -uo pipefail
POST="$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "post AppleShowAllFiles: $POST"
case "$POST" in
  1|true|TRUE|YES) echo "PASS: hidden files now shown"; exit 0 ;;
  *) echo "FAIL: expected 1/true, got '$POST'"; exit 1 ;;
esac
