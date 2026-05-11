#!/usr/bin/env bash
# Save AirDrop DiscoverableMode (or treat 'unset' as default 'Contacts Only').
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read com.apple.sharingd DiscoverableMode 2>/dev/null || echo 'Contacts Only')"
echo "$PRE" > "$HOME/.kinbench/242-pre-airdrop"
echo "→ pre-airdrop: $PRE"
