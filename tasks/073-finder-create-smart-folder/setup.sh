#!/usr/bin/env bash
# Wipe any prior 'KinBench Today' smart folder + ensure dir exists.
set -uo pipefail
SAVED="$HOME/Library/Saved Searches"
mkdir -p "$SAVED"
rm -f "$SAVED/KinBench Today.savedSearch"
echo "→ cleared prior smart folder"
