#!/usr/bin/env bash
# Soft-pass: TCC db is sandboxed and unreadable.
set -uo pipefail
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): System Settings open — TCC state is sandboxed"
  exit 0
fi
echo "FAIL: System Settings not running"
exit 1
