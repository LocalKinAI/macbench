#!/usr/bin/env bash
set -uo pipefail
# Wipe any prior burn folder so we detect a fresh creation
/bin/rm -rf "$HOME/Desktop/KinBench Burn.fpbf"
/bin/rm -rf "$HOME/Desktop/KinBench Burn"
echo "→ wiped any prior 'KinBench Burn' burn folder on Desktop"
