#!/usr/bin/env bash
# 5 lines containing "kinbench" + 3 distractors (different case or word).
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
cat > "$SANDBOX/044-input.txt" <<'EOF'
this line has kinbench in it
another kinbench mention here
KINBENCH wrong case shouldn't match
some unrelated content
kinbench again
nothing to see
KinBench mixed case shouldn't match either
matching kinbench line five
EOF
rm -f "$SANDBOX/044-count.txt"
echo "→ wrote 8-line input (5 case-sensitive matches expected)"
