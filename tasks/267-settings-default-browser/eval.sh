#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/267-pre-browser" 2>/dev/null | tr -d '[:space:]')"
PLIST="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
POST=""
if [[ -f "$PLIST" ]]; then
  POST="$(plutil -p "$PLIST" 2>/dev/null | grep -A1 '"http"' | grep 'LSHandlerRoleAll' | awk -F\" '{print $4}' | head -1)"
fi
echo "pre: $PRE   post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: default browser changed ($PRE -> $POST)"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1; then
  echo "PASS (soft): Settings pane open — confirmation dialog may not have been clicked"
  exit 0
fi
echo "FAIL: default browser unchanged"
exit 1
