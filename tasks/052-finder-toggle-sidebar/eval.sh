#!/usr/bin/env bash
# Pass: ShowSidebar is now FALSE (agent toggled from TRUE).
set -uo pipefail
POST="$(defaults read com.apple.finder ShowSidebar 2>/dev/null | tr -d '[:space:]' || echo "1")"
echo "post ShowSidebar: $POST"
case "$POST" in
  0|false|FALSE|NO) echo "PASS: sidebar toggled off"; exit 0 ;;
  *) echo "FAIL: expected 0/false, got '$POST'"; exit 1 ;;
esac
