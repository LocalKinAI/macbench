#!/bin/bash
# Reference verifier for macbench terminal (20 tasks).
# Calls cerebellum (canonical shell, no LLM) for each task.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — terminal (20 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# Originals (canonical shell + run_to_file).
run_task "024-terminal-pwd"          "$CEREB 'terminal run_to_file \"pwd\" ~/Desktop/kinbench/024-pwd.txt'"
run_task "025-terminal-create-file"  "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo hello from kinbench > ~/Desktop/kinbench/025-greeting.txt\"'"
run_task "026-terminal-pipe-output"  "$CEREB 'terminal run_to_file \"ls ~/Desktop/kinbench/026-input/*.txt 2>/dev/null | wc -l | tr -d \\\" \\\"\" ~/Desktop/kinbench/026-count.txt'"
run_task "043-terminal-git-init"     "$CEREB 'terminal git_init ~/Desktop/kinbench/043-repo'"
run_task "044-terminal-pipe-grep"    "$CEREB 'terminal run_to_file \"grep -c kinbench ~/Desktop/kinbench/044-input.txt\" ~/Desktop/kinbench/044-count.txt'"

# Terminal UI (soft-pass via confirm files).
run_task "283-terminal-open-new-window" "$CEREB 'terminal open_new_window' && $CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo window-opened > ~/Desktop/kinbench/283-confirm.txt\"'"
run_task "284-terminal-open-new-tab"    "$CEREB 'terminal open_new_tab' && $CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo tab-opened > ~/Desktop/kinbench/284-confirm.txt\"'"
run_task "285-terminal-clear-screen"    "$CEREB 'terminal clear_screen' && $CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo screen-cleared > ~/Desktop/kinbench/285-confirm.txt\"'"
run_task "286-terminal-set-tab-color"   "$CEREB 'terminal set_tab_color red' && $CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo tab-colored > ~/Desktop/kinbench/286-confirm.txt\"'"
run_task "287-terminal-rename-tab"      "$CEREB 'terminal rename_tab \"KinBench 287\"'"
run_task "288-terminal-split-pane"      "$CEREB 'terminal split_pane' && $CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && echo split-done > ~/Desktop/kinbench/288-confirm.txt\"'"
run_task "289-terminal-edit-profile"    "$CEREB 'terminal edit_profile Pro'"

# Shell pipelines via terminal run.
run_task "290-terminal-pip-install"        "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && pip3 install --user requests >/dev/null 2>&1 && pip3 show requests | grep ^Version > ~/Desktop/kinbench/290-version.txt\"'"
run_task "291-terminal-brew-list"          "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && (command -v brew >/dev/null 2>&1 && brew list || echo brew not installed) > ~/Desktop/kinbench/291-brew-list.txt\"'"
run_task "292-terminal-curl-and-save"      "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && curl -sSL https://example.com -o ~/Desktop/kinbench/292-page.html\"'"
run_task "293-terminal-grep-recursive"     "$CEREB 'terminal run_to_file \"grep -rl kinbench ~/Desktop/kinbench/293-corpus/ 2>/dev/null\" ~/Desktop/kinbench/293-matches.txt'"
run_task "294-terminal-multistep-pipeline" "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && find ~/Documents -maxdepth 1 -type f -exec stat -f %z@%N {} + 2>/dev/null | sort -t@ -k1 -rn | head -n 5 | cut -d@ -f2- | xargs -n1 basename > ~/Desktop/kinbench/294-top5.txt\"'"
run_task "295-terminal-script-creation"    "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && printf %s\\\\n \\\"#!/bin/sh\\\" \\\"echo hello kinbench\\\" > ~/Desktop/kinbench/295-script.sh && chmod +x ~/Desktop/kinbench/295-script.sh && ~/Desktop/kinbench/295-script.sh > ~/Desktop/kinbench/295-output.txt\"'"
run_task "296-terminal-process-management" "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && open -ga TextEdit; sleep 1; PID=\\\$(pgrep -x TextEdit | head -n1); if [ -n \\\"\\\$PID\\\" ]; then kill -TERM \\\$PID 2>/dev/null; echo killed PID \\\$PID > ~/Desktop/kinbench/296-kill.txt; else echo killed PID 0 > ~/Desktop/kinbench/296-kill.txt; fi\"'"
run_task "297-terminal-network-diagnose"   "$CEREB 'terminal run \"mkdir -p ~/Desktop/kinbench && (ping -c 3 apple.com; traceroute -m 5 apple.com) > ~/Desktop/kinbench/297-diagnose.txt 2>&1\"'"

verify_done "terminal"
