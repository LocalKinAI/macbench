#!/bin/bash
# Reference verifier for macbench music (10 tasks).
# Calls cerebellum (canonical AppleScript, no LLM) for each task.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — music (10 tasks)"
echo "═══════════════════════════════════════════════════════════════"

run_task "336-music-play-pause"        "$CEREB 'music play_pause'"
run_task "337-music-skip-forward"      "$CEREB 'music next'"
run_task "338-music-volume-down"       "$CEREB 'music volume_down'"
run_task "339-music-create-playlist"   "$CEREB 'music create_playlist \"KinBench Mix 339\"'"
run_task "340-music-add-to-playlist"   "$CEREB 'music add_to_playlist \"KinBench Mix 340\" \"\"'"
run_task "341-music-search-library"    "$CEREB 'music search_track \"\" ~/Desktop/kinbench/341-search.txt'"
run_task "342-music-play-album"        "$CEREB 'music play_album \"\"'"
run_task "343-music-shuffle-toggle"    "$CEREB 'music shuffle_toggle'"
run_task "344-music-export-playlist"   "$CEREB 'music export_playlist \"KinBench Mix 344\" ~/Desktop/kinbench/344-tracks.txt'"
run_task "345-music-stats-most-played" "$CEREB 'music most_played ~/Desktop/kinbench/345-top.txt'"

verify_done "music"
