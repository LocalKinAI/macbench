#!/usr/bin/env bash
set -uo pipefail
rm -f "$HOME/Library/Saved Searches/KinBench Today.savedSearch"
find "$HOME/Library/Saved Searches" -maxdepth 1 -iname '*kinbench*' -delete 2>/dev/null || true
