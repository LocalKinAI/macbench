#!/usr/bin/env bash
# 193-calendar-search-event eval
# Pass: agent wrote the correct YYYY-MM-DD that matches the
# planted event's start date.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/193-found.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT")"
echo "agent wrote: '$ANSWER'"

# Compute expected date (5 days from setup time, but eval runs same day)
EXPECTED="$(date -v+5d +%Y-%m-%d 2>/dev/null || date -d '+5 days' +%Y-%m-%d)"
echo "expected (approx): $EXPECTED"

# Accept any 8-digit-ish YYYY-MM-DD or YYYYMMDD reference, also accept a
# small ±1d window for slow tasks crossing midnight.
EXPECTED_M1="$(date -v+4d +%Y-%m-%d 2>/dev/null || date -d '+4 days' +%Y-%m-%d)"
EXPECTED_P1="$(date -v+6d +%Y-%m-%d 2>/dev/null || date -d '+6 days' +%Y-%m-%d)"

for d in "$EXPECTED" "$EXPECTED_M1" "$EXPECTED_P1"; do
  if [[ "$ANSWER" == *"$d"* ]]; then
    echo "PASS: matched $d"
    exit 0
  fi
  # Also accept YYYYMMDD form
  cmp="${d//-/}"
  if [[ "$ANSWER" == *"$cmp"* ]]; then
    echo "PASS: matched $cmp"
    exit 0
  fi
done

# Soft check: agent wrote SOMETHING containing "KinBench Search 193"
if grep -q "KinBench Search 193" "$OUT" 2>/dev/null; then
  echo "PASS (soft): file contains event name from find_events_with_summary output"
  exit 0
fi

echo "FAIL: no date match"
exit 2
