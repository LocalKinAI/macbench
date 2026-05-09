#!/usr/bin/env bash
# Stash whether Focus is currently on (so we can restore in teardown).
# Focus state on macOS 13+ lives in com.apple.controlcenter / NSUbiquitous
# but the easiest tellable signal is `ASN.NotificationManager` defaults
# under com.apple.donotdisturb — which has been removed in macOS 12+.
#
# We use `defaults read com.apple.controlcenter "FocusModes"` as a probe;
# absence == off. There's no fully clean machine-readable check
# pre-Sonoma; we accept eval that just checks "any focus is active".
set -uo pipefail
mkdir -p "$HOME/.kinbench"

# Active focus indicator: NSStatusItem in menu bar shows a moon/etc.
# Programmatic probe via plist:
PRE="$(defaults read /Library/Preferences/com.apple.controlcenter "NSStatusItem Visible FocusModes" 2>/dev/null || echo "?")"
echo "$PRE" > "$HOME/.kinbench/021-pre-focus"
echo "→ pre-state recorded: $PRE"
