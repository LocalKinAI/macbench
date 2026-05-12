#!/bin/bash
# Reference verifier for macbench photos (10 tasks).
# Calls cerebellum (canonical AppleScript + UI scripting, no LLM) for
# each task. Most photo UI ops are soft-pass: cerebellum drives the UI
# and writes a confirm file because Photos AS dict can't read result.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — photos (10 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# Each task names a "recent photo" — cerebellum's set_favorite with empty
# name acts on the most recent library photo; same shape for others.
run_task "346-photos-favorite"          "$CEREB 'photos set_favorite \"\"'"
run_task "347-photos-show-info"         "$CEREB 'photos show_info \"\" ~/Desktop/kinbench/347-confirm.txt'"
run_task "348-photos-rotate-photo"      "$CEREB 'photos rotate_photo \"\" cw ~/Desktop/kinbench/348-confirm.txt'"
run_task "349-photos-create-album"      "$CEREB 'photos create_album \"KinBench Album 349\"'"
run_task "350-photos-add-to-album"      "$CEREB 'photos add_to_album \"KinBench Album 350\" \"\"'"
run_task "351-photos-edit-crop"         "$CEREB 'photos edit_crop \"\" ~/Desktop/kinbench/351-confirm.txt'"
run_task "352-photos-edit-filter"       "$CEREB 'photos edit_filter \"\" Vivid ~/Desktop/kinbench/352-confirm.txt'"
run_task "353-photos-create-memory"     "$CEREB 'photos create_memory \"KinBench Album 353\" ~/Desktop/kinbench/353-confirm.txt'"
run_task "354-photos-search-then-tag"   "$CEREB 'photos search_then_tag \"\" ~/Desktop/kinbench/354-count.txt'"
run_task "355-photos-export-album"      "$CEREB 'photos export_album \"KinBench Album 355\" ~/Desktop/kinbench/355-export'"

verify_done "photos"
