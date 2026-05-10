#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/062-search-results.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
echo "results file:"
/bin/cat "$F" | /usr/bin/sed 's/^/  | /'
needed=("kinbench-search-062-alpha" "kinbench-search-062-bravo" "kinbench-search-062-charlie")
for n in "${needed[@]}"; do
  if ! /usr/bin/grep -q "$n" "$F"; then
    echo "FAIL: missing match: $n"
    exit 2
  fi
done
# Make sure distractors didn't leak
if /usr/bin/grep -q "062-distractor" "$F"; then
  echo "FAIL: distractor leaked into results"
  exit 3
fi
echo "PASS: all 3 matches present, no distractors leaked"
exit 0
