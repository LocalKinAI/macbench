#!/usr/bin/env bash
set -uo pipefail
POST="$(/usr/bin/defaults read com.apple.finder FXPreferredGroupBy 2>/dev/null | /usr/bin/tr -d '[:space:]"' || echo "")"
echo "post FXPreferredGroupBy: '$POST'"
POST_LC="$(printf '%s' "$POST" | /usr/bin/tr '[:upper:]' '[:lower:]')"
case "$POST_LC" in
  size) echo "PASS: switched to Size sort"; exit 0 ;;
esac
echo "FAIL: expected Size, got '$POST'"
exit 1
