#!/usr/bin/env bash
# 001-finder-rename setup
#
# Writes a known file to the sandbox dir so the agent has something
# to rename. Wipes any leftover output from a prior run.

set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/001-output.txt"
printf 'kinbench-001 fixture\n' > "$SANDBOX/001-input.txt"
echo "→ wrote $SANDBOX/001-input.txt"
