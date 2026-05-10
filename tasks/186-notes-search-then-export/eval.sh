#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/186-export.pdf"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
file "$F" | grep -qi "PDF document" || { echo "FAIL: not a valid PDF"; exit 2; }
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 1000 ]] || { echo "FAIL: PDF too small ($SIZE bytes)"; exit 3; }

# Soft-check: if pdftotext is available, verify the PDF is the right note (contains PINEAPPLE-MARKER)
if command -v pdftotext >/dev/null 2>&1; then
  TXT="$(pdftotext "$F" - 2>/dev/null || true)"
  if printf '%s' "$TXT" | grep -q "PINEAPPLE-MARKER-186"; then
    echo "PASS: PDF saved and contains the target marker ($SIZE bytes)"
    exit 0
  fi
  echo "FAIL: PDF saved but does not contain PINEAPPLE-MARKER-186 (wrong note exported?)"
  exit 4
fi

echo "PASS: PDF saved ($SIZE bytes) — pdftotext not installed, content not verified"
exit 0
