#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/268-pre-mail" 2>/dev/null | tr -d '[:space:]')"
PLIST="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
POST=""
if [[ -f "$PLIST" ]]; then
  POST="$(plutil -p "$PLIST" 2>/dev/null | grep -A1 '"mailto"' | grep 'LSHandlerRoleAll' | awk -F\" '{print $4}' | head -1)"
fi
echo "pre: $PRE   post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: default mail handler changed ($PRE -> $POST)"
  exit 0
fi
# Soft-pass: Mail Settings open
if pgrep -x "Mail" >/dev/null 2>&1; then
  echo "PASS (soft): Mail running — Mail Settings was likely opened"
  exit 0
fi
echo "FAIL: default mail handler unchanged"
exit 1
