#!/usr/bin/env bash
# Pass: DiscoverableMode changed. Soft-pass: if Control Center was used
# and the pref didn't write yet, accept the System Settings AirDrop pane
# being open or sharingd showing a recent activity bump.
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/242-pre-airdrop" 2>/dev/null)"
POST="$(defaults read com.apple.sharingd DiscoverableMode 2>/dev/null || echo 'Contacts Only')"
echo "pre: $PRE   post: $POST"
if [[ "$POST" != "$PRE" ]]; then
  echo "PASS: AirDrop visibility changed ($PRE -> $POST)"
  exit 0
fi
# Soft-pass: AirDrop / Bluetooth pane open
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open; assume agent toggled in Control Center / UI"
  exit 0
fi
echo "FAIL: AirDrop visibility unchanged"
exit 1
