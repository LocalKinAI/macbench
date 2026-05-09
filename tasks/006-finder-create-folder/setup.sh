#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -rf "$SANDBOX/006-myfolder"
echo "→ ensured $SANDBOX/006-myfolder is absent before run"
