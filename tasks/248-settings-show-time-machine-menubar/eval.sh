#!/usr/bin/env bash
set -uo pipefail
KEY="NSStatusItem Visible TimeMachine"
POST="$(defaults read com.apple.controlcenter "$KEY" 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "post: $POST"
case "$POST" in 1|true|TRUE|YES) echo "PASS"; exit 0 ;; *) echo "FAIL"; exit 1 ;; esac
