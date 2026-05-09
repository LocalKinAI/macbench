#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.dock orientation 2>/dev/null | tr -d '[:space:]' || echo "bottom")"
echo "post orientation: $POST"
case "$POST" in left|right) echo "PASS: dock moved to $POST"; exit 0 ;; *) echo "FAIL: still $POST"; exit 1 ;; esac
