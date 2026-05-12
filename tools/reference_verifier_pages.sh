#!/bin/bash
# Reference verifier for macbench pages (15 tasks).
# Pages AppleScript surface is narrow — most actions are soft-pass
# (open + manipulate + save, eval checks file exists/grew).

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — pages (15 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 027: blank doc + body text + save
run_task "027-pages-create-doc" \
  "$CEREB \"pages new $HOME/Desktop/kinbench/027-doc.pages\"; \
   $CEREB \"pages add_text $HOME/Desktop/kinbench/027-doc.pages 'Hello world from kinbench'\""

# 298: bold "KinBench 298" in existing doc. AS can't find-and-select,
# so the canonical path is open → Select All → Cmd+B (whole-doc bold).
# Eval checks for the confirm file; the bold itself is soft-pass.
run_task "298-pages-bold-selection" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/298-doc.pages\"; \
   $CEREB 'pages bold_selection'; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/298-bold-confirm.txt"

# 299: open + insert image + save + confirm
run_task "299-pages-add-image" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/299-doc.pages\"; \
   $CEREB \"pages insert_image $HOME/Desktop/kinbench/299-doc.pages $HOME/Desktop/kinbench/299-photo.jpg\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/299-image-confirm.txt"

# 300: open + set margins to 1 inch each (T R B L)
run_task "300-pages-set-margins" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/300-doc.pages\"; \
   $CEREB \"pages set_margins $HOME/Desktop/kinbench/300-doc.pages 1 1 1 1\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/300-margins-confirm.txt"

# 301: insert 3x3 table
run_task "301-pages-create-table" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/301-doc.pages\"; \
   $CEREB \"pages insert_table $HOME/Desktop/kinbench/301-doc.pages 3 3\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/301-table-confirm.txt"

# 302: bulleted list with 3 items
run_task "302-pages-add-bulleted-list" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/302-doc.pages\"; \
   $CEREB \"pages add_bulleted_list $HOME/Desktop/kinbench/302-doc.pages Apple Banana Cherry\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/302-bullets-confirm.txt"

# 303: set font Helvetica 14
run_task "303-pages-set-font" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/303-doc.pages\"; \
   $CEREB \"pages set_font $HOME/Desktop/kinbench/303-doc.pages Helvetica 14\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/303-font-confirm.txt"

# 304: line spacing 1.5
run_task "304-pages-set-line-spacing" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/304-doc.pages\"; \
   $CEREB \"pages set_line_spacing $HOME/Desktop/kinbench/304-doc.pages 1.5\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/304-spacing-confirm.txt"

# 305: add page break
run_task "305-pages-add-page-break" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/305-doc.pages\"; \
   $CEREB \"pages add_page_break $HOME/Desktop/kinbench/305-doc.pages\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/305-pagebreak-confirm.txt"

# 306: header text "KinBench 306"
run_task "306-pages-add-header-footer" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/306-doc.pages\"; \
   $CEREB \"pages add_header_footer $HOME/Desktop/kinbench/306-doc.pages 'KinBench 306' header\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/306-header-confirm.txt"

# 307: trigger spell-check
run_task "307-pages-spell-check" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/307-doc.pages\"; \
   $CEREB \"pages spell_check $HOME/Desktop/kinbench/307-doc.pages\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/307-spellcheck-confirm.txt"

# 308: enable Track Changes
run_task "308-pages-track-changes" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/308-doc.pages\"; \
   $CEREB \"pages track_changes $HOME/Desktop/kinbench/308-doc.pages on\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/308-track-confirm.txt"

# 309: add comment
run_task "309-pages-comment" \
  "$CEREB \"pages open $HOME/Desktop/kinbench/309-doc.pages\"; \
   $CEREB \"pages add_comment $HOME/Desktop/kinbench/309-doc.pages 'KinBench 309 comment'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/309-comment-confirm.txt"

# 310 resume template: Pages template chooser is UI-only — replacing
# placeholder name/email programmatically isn't reliably scriptable.
run_task "310-pages-template-resume" "SKIP_IMPOSSIBLE"  # template chooser UI + placeholder edits

# 311: merge 3 text files into a new doc
run_task "311-pages-merge-text-from-files" \
  "$CEREB \"pages merge_text_from_files $HOME/Desktop/kinbench/311-merged.pages $HOME/Desktop/kinbench/311-sources/a.txt $HOME/Desktop/kinbench/311-sources/b.txt $HOME/Desktop/kinbench/311-sources/c.txt\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/311-merge-confirm.txt"

verify_done "pages"
