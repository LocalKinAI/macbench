#!/usr/bin/env bash
# Soft-pass setup. We DO NOT actually toggle Wi-Fi here (or force it
# On) — the bench previously turned Wi-Fi off mid-run as a side-effect
# of grep_route picking up the FIRST cerebellum hint from the prompt
# ("toggle_wifi OFF") and not the FOLLOWUP "toggle_wifi ON". That
# interrupted everything (network, agent LLM, etc.). We now treat
# this task as a control-surface awareness check: agent must write
# a confirmation file; no real wifi disruption.
set -uo pipefail
mkdir -p "$HOME/.kinbench" "$HOME/Desktop/kinbench"
# Snapshot current state for the record, but do not modify it.
IFACE="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')"
[[ -z "$IFACE" ]] && IFACE="en0"
PRE="$(networksetup -getairportpower "$IFACE" 2>/dev/null | awk '{print $NF}')"
echo "$IFACE" > "$HOME/.kinbench/241-pre-wifi-iface"
echo "$PRE"   > "$HOME/.kinbench/241-pre-wifi-state"
rm -f "$HOME/Desktop/kinbench/241-wifi-confirm.txt"
echo "→ recorded wifi=$PRE on $IFACE (will NOT be modified by bench)"
