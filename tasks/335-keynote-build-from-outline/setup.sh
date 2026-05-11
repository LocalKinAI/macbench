#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/335-outline.md"
rm -rf "$HOME/Desktop/kinbench/335-deck.key"
rm -f "$HOME/Desktop/kinbench/335-outline-confirm.txt"

cat > "$HOME/Desktop/kinbench/335-outline.md" <<'MD'
# KinBench Intro
- Welcome
- Agenda

# Why benchmark
- Reproducible
- Local-first

# Architecture
- 5 claws
- Cerebellum dispatcher

# Results
- 67.3 percent on macbench v0.1
- Genesis loop validated

# Next steps
- More categories
- Public release
MD

osascript -e 'tell application "Keynote" to quit' >/dev/null 2>&1 || true
sleep 0.4
echo "→ wrote 335-outline.md, cleared 335-deck.key"
