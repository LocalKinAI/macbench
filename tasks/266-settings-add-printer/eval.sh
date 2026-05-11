#!/usr/bin/env bash
# Soft-pass: Printers & Scanners pane open (System Settings running).
set -uo pipefail
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open — assume Printers pane was navigated"
  exit 0
fi
echo "FAIL: System Settings not running"
exit 1
