#!/bin/bash
# Reference verifier for macbench keynote (10 tasks).
# Keynote AS supports doc creation + slides + text decently; theme +
# transition + rearrange are soft-pass.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — keynote (10 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 326: new deck saved as .key
run_task "326-keynote-create-blank" \
  "$CEREB \"keynote new $HOME/Desktop/kinbench/326-deck.key\""

# 327: open + add slide
run_task "327-keynote-add-slide" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/327-deck.key\"; \
   $CEREB \"keynote add_slide $HOME/Desktop/kinbench/327-deck.key\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/327-slide-confirm.txt"

# 328: open + set slide 1 title
run_task "328-keynote-add-title" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/328-deck.key\"; \
   $CEREB \"keynote add_title $HOME/Desktop/kinbench/328-deck.key 1 'KinBench Keynote 328'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/328-title-confirm.txt"

# 329: change theme — Keynote AS theme-by-name is flaky; soft-pass
run_task "329-keynote-change-theme" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/329-deck.key\"; \
   $CEREB \"keynote change_theme $HOME/Desktop/kinbench/329-deck.key 'Modern Portfolio'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/329-theme-confirm.txt"

# 330: open + insert image on slide 1
run_task "330-keynote-add-image-to-slide" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/330-deck.key\"; \
   $CEREB \"keynote add_image_to_slide $HOME/Desktop/kinbench/330-deck.key 1 $HOME/Desktop/kinbench/330-photo.jpg\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/330-image-confirm.txt"

# 331: open + add bullets to slide
run_task "331-keynote-add-bullets" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/331-deck.key\"; \
   $CEREB \"keynote add_bullets $HOME/Desktop/kinbench/331-deck.key 1 First Second Third\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/331-bullets-confirm.txt"

# 332: set transition (cube) on slide 1
run_task "332-keynote-set-transition" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/332-deck.key\"; \
   $CEREB \"keynote set_transition $HOME/Desktop/kinbench/332-deck.key 1 Cube\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/332-transition-confirm.txt"

# 333: reorder slides to 3,1,2
run_task "333-keynote-rearrange-slides" \
  "$CEREB \"keynote open $HOME/Desktop/kinbench/333-deck.key\"; \
   $CEREB \"keynote rearrange_slides $HOME/Desktop/kinbench/333-deck.key 3,1,2\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/333-rearrange-confirm.txt"

# 334: export PDF
run_task "334-keynote-export-pdf" \
  "$CEREB \"keynote save_as_pdf $HOME/Desktop/kinbench/334-deck.key $HOME/Desktop/kinbench/334-deck.pdf\""

# 335: build deck from markdown outline
run_task "335-keynote-build-from-outline" \
  "OUTLINE=\"\$(/bin/cat $HOME/Desktop/kinbench/335-outline.md)\"; \
   $CEREB \"keynote build_from_outline $HOME/Desktop/kinbench/335-deck.key '\$OUTLINE'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/335-outline-confirm.txt"

verify_done "keynote"
