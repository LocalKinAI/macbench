#!/usr/bin/env bash
PRE="$(cat "$HOME/.kinbench/343-pre" 2>/dev/null | tr -d '[:space:]')"
osascript -e "tell application \"Music\" to set shuffle enabled to (\"$PRE\" = \"true\")" 2>/dev/null || true
