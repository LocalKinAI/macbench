#!/usr/bin/env bash
# Snapshot the current http handler from LaunchServices.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PLIST="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
PRE=""
if [[ -f "$PLIST" ]]; then
  PRE="$(plutil -p "$PLIST" 2>/dev/null | grep -A1 '"http"' | grep 'LSHandlerRoleAll' | awk -F\" '{print $4}' | head -1)"
fi
[[ -z "$PRE" ]] && PRE="com.apple.safari"
echo "$PRE" > "$HOME/.kinbench/267-pre-browser"
echo "→ pre-default-browser-http-handler: $PRE"
