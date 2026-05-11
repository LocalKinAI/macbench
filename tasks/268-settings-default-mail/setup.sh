#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PLIST="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
PRE=""
if [[ -f "$PLIST" ]]; then
  PRE="$(plutil -p "$PLIST" 2>/dev/null | grep -A1 '"mailto"' | grep 'LSHandlerRoleAll' | awk -F\" '{print $4}' | head -1)"
fi
[[ -z "$PRE" ]] && PRE="com.apple.mail"
echo "$PRE" > "$HOME/.kinbench/268-pre-mail"
echo "→ pre-default-mail-handler: $PRE"
