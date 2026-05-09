#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.finder ShowHardDrivesOnDesktop 2>/dev/null | tr -d '[:space:]' || echo "0")"
echo "post ShowHardDrivesOnDesktop: $POST"
case "$POST" in
  1|true|TRUE|YES) echo "PASS: hard disks now shown on desktop"; exit 0 ;;
  *) echo "FAIL: expected 1/true, got '$POST'"; exit 1 ;;
esac
