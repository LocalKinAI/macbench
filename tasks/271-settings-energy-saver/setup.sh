#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(pmset -g | awk '/^ displaysleep/{print $2}' || echo "10")"
echo "$PRE" > "$HOME/.kinbench/271-pre"
echo "→ current displaysleep: $PRE min"
