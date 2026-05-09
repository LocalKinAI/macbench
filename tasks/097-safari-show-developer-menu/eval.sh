#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.Safari IncludeDevelopMenu 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "post: $POST"
case "$POST" in 1|true|TRUE|YES) echo "PASS"; exit 0 ;; *) echo "FAIL"; exit 1 ;; esac
