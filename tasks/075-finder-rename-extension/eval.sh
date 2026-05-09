#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
[[ -f "$SANDBOX/075-doc.md"  ]] || { echo "FAIL: 075-doc.md missing"; exit 1; }
[[ ! -f "$SANDBOX/075-doc.txt" ]] || { echo "FAIL: 075-doc.txt still exists (rename should have removed it)"; exit 2; }
CONTENT="$(cat "$SANDBOX/075-doc.md")"
[[ "$CONTENT" == "kinbench-075 markdown body" ]] || { echo "FAIL: content mangled: '$CONTENT'"; exit 3; }
echo "PASS: extension renamed, content preserved"
exit 0
