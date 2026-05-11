#!/usr/bin/env bash
# Record current Wi-Fi state + iface for eval.
set -uo pipefail
mkdir -p "$HOME/.kinbench"

IFACE="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')"
[[ -z "$IFACE" ]] && IFACE="en0"

PRE="$(networksetup -getairportpower "$IFACE" 2>/dev/null | awk '{print $NF}')"
[[ -z "$PRE" ]] && PRE="On"

echo "$IFACE" > "$HOME/.kinbench/241-pre-wifi-iface"
echo "$PRE"   > "$HOME/.kinbench/241-pre-wifi-state"
# Force Wi-Fi On at start so agent must toggle Off then On (sees a change)
networksetup -setairportpower "$IFACE" on >/dev/null 2>&1 || true
echo "→ pre-wifi: iface=$IFACE state=$PRE"
