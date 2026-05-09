#!/usr/bin/env bash
# 004-settings-dark-mode setup
#
# Force Light mode so the eval can detect a real switch.
# Stash the current setting so teardown.sh can restore it.

set -uo pipefail
ORIG_DIR="$HOME/.kinbench"
mkdir -p "$ORIG_DIR"

# Save the original value (could be "Dark", or empty meaning Light).
defaults read -g AppleInterfaceStyle 2>/dev/null > "$ORIG_DIR/004-orig-mode" || \
  echo "Light" > "$ORIG_DIR/004-orig-mode"

# Force Light mode via AppleScript (touches the system pref reliably).
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false' 2>/dev/null || true

# Verify we're in Light now.
sleep 0.5
CURRENT="$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)"
echo "→ pre-state: $CURRENT (saved original to $ORIG_DIR/004-orig-mode)"
