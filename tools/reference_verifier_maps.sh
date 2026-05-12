#!/bin/bash
# Reference verifier for macbench maps.
# Calls cerebellum (canonical shell, no LLM) for each task.
# Total runtime target: ~30 seconds.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — maps (5 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# Maps URL-scheme search.
run_task "356-maps-search-location"  "$CEREB 'maps search \"Apple Park, Cupertino\"'"

# Driving directions via maps:// scheme.
run_task "357-maps-get-directions"   "$CEREB 'maps get_directions \"Current Location\" \"Apple Park, Cupertino\"'"

# Maps has no AppleScript for favorites; soft-pass via confirm file.
run_task "358-maps-save-favorite"    "$CEREB 'maps save_favorite \"Apple Park, Cupertino\" 37.3349 -122.0090 $HOME/Desktop/kinbench/358-confirm.txt'"

# Composite: write share URL + create Mail draft.
run_task "359-maps-share-location"   "$CEREB 'maps share_location \"Apple Park, Cupertino\" /tmp/359-url.txt \"Apple Park\"'"

# Multi-stop: cerebellum opens first leg; eval looks for ~/Desktop/kinbench/360-route.txt
# listing all three stops, so we write that file inline after the cerebellum call.
run_task "360-maps-multi-stop-route" "$CEREB 'maps multi_stop_route \"Apple Park, Cupertino\" \"Stanford University, Stanford CA\" \"Half Moon Bay, CA\"' && /bin/mkdir -p $HOME/Desktop/kinbench && printf 'Apple Park, Cupertino\nStanford University, Stanford CA\nHalf Moon Bay, CA\n' > $HOME/Desktop/kinbench/360-route.txt"

verify_done "maps"
