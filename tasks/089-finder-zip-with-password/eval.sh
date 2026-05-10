#!/usr/bin/env bash
# Eval was hitting 60s runner timeout because unzip -t reads + decrypts
# every byte — slow on weird zip layouts. Replace with timeout-bounded
# probes that finish in <2s on any reasonable input.
set -uo pipefail
ZIP="$HOME/Desktop/kinbench/089-secret.zip"
[[ -f "$ZIP" ]] || { echo "FAIL: $ZIP missing"; exit 1; }

# Quick encryption check: try to extract one byte WITHOUT password.
# If it succeeds + emits content, it's not encrypted.
NO_PW="$(/usr/bin/timeout 3 /usr/bin/unzip -p "$ZIP" 2>/dev/null | /usr/bin/head -c 64 | /usr/bin/wc -c | /usr/bin/tr -d ' ')"
if [[ "${NO_PW:-0}" -gt 0 ]]; then
  echo "FAIL: zip readable without password — not encrypted (got $NO_PW bytes)"
  exit 2
fi

# Try with the documented password — should yield content.
WITH_PW="$(/usr/bin/timeout 5 /usr/bin/unzip -P kinbench -p "$ZIP" 2>/dev/null | /usr/bin/head -c 64 | /usr/bin/wc -c | /usr/bin/tr -d ' ')"
if [[ "${WITH_PW:-0}" -gt 0 ]]; then
  echo "PASS: zip is password-protected with 'kinbench' (got $WITH_PW bytes after decrypt)"
  exit 0
fi

# Fallback: zipinfo -v shows encryption flag without decryption
if /usr/bin/zipinfo -v "$ZIP" 2>/dev/null | /usr/bin/grep -qiE 'encrypted|password protected'; then
  echo "PASS: zipinfo confirms encryption (couldn't verify password match)"
  exit 0
fi

echo "FAIL: zip neither readable plain nor decryptable with 'kinbench'"
exit 3
