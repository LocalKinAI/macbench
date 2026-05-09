#!/usr/bin/env bash
# 005-finder-zip eval
#
# Pass criteria:
#   - 005-archive.zip exists
#   - It contains a.txt, b.txt, c.txt (in any order, any path)
#   - Each member round-trips to its expected content

set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
ZIP="$SANDBOX/005-archive.zip"

if [[ ! -f "$ZIP" ]]; then
  echo "FAIL: $ZIP missing"
  exit 1
fi

# Use plain `unzip -l` and grep for member names directly. The
# previous `tail -n +4 | head -n -2` trim used GNU-only `head -n -N`
# which BSD/macOS head doesn't support → eval mis-reported missing.
LIST="$(unzip -l "$ZIP" 2>&1)"
echo "archive contents:"
echo "$LIST"

for member in a.txt b.txt c.txt; do
  # Skip the "summary" lines unzip prints; member names appear as
  # whitespace-suffixed full paths.
  if ! echo "$LIST" | grep -qE "[[:space:]]${member}\$|/${member}\$"; then
    echo "FAIL: $member missing from archive"
    exit 2
  fi
done

# Verify round-trip integrity (catches "agent zipped wrong files
# but with right names" edge case).
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
if ! unzip -q -j "$ZIP" -d "$TMP"; then
  echo "FAIL: archive corrupt or unzip failed"
  exit 3
fi

for f in a b c; do
  EXPECTED="${f} file content"
  ACTUAL="$(cat "$TMP/${f}.txt" 2>/dev/null || true)"
  if [[ "$ACTUAL" != "$EXPECTED" ]]; then
    echo "FAIL: ${f}.txt content '$ACTUAL' != expected '$EXPECTED'"
    exit 4
  fi
done

echo "PASS: archive contains a.txt b.txt c.txt with correct content"
exit 0
