#!/usr/bin/env bash
# Add a sentinel Login Item the agent must disable / remove.
# Use TextEdit as a stand-in non-essential app (it IS Apple-signed, but
# the test is whether the agent disables a user-added Login Item, which
# is what 'bulk-disable-startup' really means in practice).
set -uo pipefail
mkdir -p "$HOME/.kinbench"
# Record the baseline list
BEFORE="$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "")"
echo "$BEFORE" > "$HOME/.kinbench/280-pre-login"
# Add TextEdit if it's not already there
if ! echo "$BEFORE" | grep -q "TextEdit"; then
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/System/Applications/TextEdit.app", hidden:false}' 2>/dev/null || true
fi
AFTER="$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "")"
echo "→ pre-list: $BEFORE"
echo "→ post-inject-list: $AFTER"
