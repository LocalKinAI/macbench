#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/062-search-results.txt"
# Plant 3 matches + 2 distractors
/usr/bin/touch "$SANDBOX/kinbench-search-062-alpha.txt"
/usr/bin/touch "$SANDBOX/kinbench-search-062-bravo.txt"
/usr/bin/touch "$SANDBOX/kinbench-search-062-charlie.txt"
/usr/bin/touch "$SANDBOX/062-distractor-one.txt"
/usr/bin/touch "$SANDBOX/062-distractor-two.txt"
echo "→ planted 3 matches + 2 distractors in $SANDBOX"
