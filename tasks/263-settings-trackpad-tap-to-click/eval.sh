#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/263-pre" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults read com.apple.AppleMultitouchTrackpad Clicking 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "pre: $PRE  post: $POST"
[[ "$POST" != "$PRE" ]] && { echo "PASS: tap-to-click toggled"; exit 0; }
echo "FAIL: unchanged"
exit 1
