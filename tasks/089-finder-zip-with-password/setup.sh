#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/089-secret"
rm -rf "$DIR" "$HOME/Desktop/kinbench/089-secret.zip"
mkdir -p "$DIR"
printf 'classified\n' > "$DIR/secret-doc.txt"
echo "→ planted secret-doc.txt"
