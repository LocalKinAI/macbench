#!/usr/bin/env bash
set -uo pipefail
EXPECTED="$(cat "$HOME/.kinbench/020-expected-day" 2>/dev/null)"
OUT="$HOME/Desktop/kinbench/020-day.txt"

if [[ -z "$EXPECTED" ]]; then
  echo "FAIL: setup didn't stash expected day"
  exit 3
fi
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT not written"
  exit 1
fi

ANSWER="$(tr -d '[:space:]' < "$OUT")"
echo "expected: $EXPECTED   answer: $ANSWER"

ANSWER_LC="$(printf '%s' "$ANSWER" | tr '[:upper:]' '[:lower:]')"
EXPECTED_LC="$(printf '%s' "$EXPECTED" | tr '[:upper:]' '[:lower:]')"
if [[ "$ANSWER_LC" == "$EXPECTED_LC" ]]; then
  echo "PASS"
  exit 0
fi
echo "FAIL: answer doesn't match expected day name"
exit 2
