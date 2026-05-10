#!/usr/bin/env bash
# A burn folder is a directory whose name ends in .fpbf (Finder Pseudo Burn
# Folder bundle). It contains an Info.plist and an empty content tree;
# Finder treats the bundle as a folder for staging files to burn.
set -uo pipefail
B="$HOME/Desktop/KinBench Burn.fpbf"
[[ -d "$B" ]] || { echo "FAIL: $B missing (no .fpbf burn folder created)"; exit 1; }
echo "PASS: burn folder $B exists"
exit 0
