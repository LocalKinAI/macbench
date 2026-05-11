#!/usr/bin/env bash
# SearchProviderIdentifier lives in com.apple.Safari prefs. After
# changing the engine in the Settings UI, this key updates.
set -uo pipefail
sleep 1
POST="$(defaults read com.apple.Safari SearchProviderIdentifier 2>/dev/null || echo '')"
echo "post engine: $POST"
case "$POST" in
  *duckduckgo*|*DuckDuckGo*|*ddg*) echo "PASS: DuckDuckGo set"; exit 0 ;;
esac
echo "FAIL: SearchProviderIdentifier is not DuckDuckGo ($POST)"
exit 1
