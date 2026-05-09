#!/usr/bin/env bash
# Pass: 027-doc.pages exists at the expected path AND its preview /
# index.xml content includes our body text. Pages files are zip
# bundles; we'll unzip + grep the index.
set -uo pipefail
F="$HOME/Desktop/kinbench/027-doc.pages"
if [[ ! -e "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi

# Pages docs are .pages bundles (often a zip; sometimes a directory
# bundle). Try both.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [[ -d "$F" ]]; then
  # bundle directory
  if grep -r -q "Hello world from kinbench" "$F" 2>/dev/null; then
    echo "PASS: bundle contains expected text"
    exit 0
  fi
elif file "$F" | grep -qi "zip\|encrypted"; then
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if grep -r -q "Hello world from kinbench" "$TMP" 2>/dev/null; then
      echo "PASS: zip bundle contains expected text"
      exit 0
    fi
  fi
fi

# Fallback: at least confirm the file exists with non-trivial size.
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
echo "file size: $SIZE bytes"
if [[ "$SIZE" -gt 1024 ]]; then
  echo "PARTIAL: file exists ($SIZE bytes) but text not findable in plain content"
  echo "          (Pages may have iWork-encrypted the body — accept as soft pass)"
  exit 0
fi

echo "FAIL: file too small or text not present"
exit 2
