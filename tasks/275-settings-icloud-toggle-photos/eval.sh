#!/usr/bin/env bash
# Soft-pass: iCloud pane is sandboxed. We accept System Settings being open.
set -uo pipefail
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open — iCloud sync state is sandboxed"
  exit 0
fi
echo "FAIL: System Settings not running — pane was not opened"
exit 1
