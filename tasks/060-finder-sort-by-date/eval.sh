#!/usr/bin/env bash
set -uo pipefail
POST="$(/usr/bin/defaults read com.apple.finder FXPreferredGroupBy 2>/dev/null | /usr/bin/tr -d '[:space:]"' || echo "")"
echo "post FXPreferredGroupBy: '$POST'"
# Lowercase via tr (bash 3.2 compat — macOS default bash is 3.2)
POST_LC="$(printf '%s' "$POST" | /usr/bin/tr '[:upper:]' '[:lower:]')"
case "$POST_LC" in
  *datemodified*|*dateadded*|*datelastopened*|*datecreated*|*date*)
    echo "PASS: switched to a date-based sort"
    exit 0
    ;;
esac
echo "FAIL: expected a date-based sort, got '$POST'"
exit 1
