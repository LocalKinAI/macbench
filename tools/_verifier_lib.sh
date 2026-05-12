#!/bin/bash
# Shared helpers for reference verifiers. Source this from each
# category-specific verifier. Provides:
#   run_task <task_id> <cerebellum_action_or_shell>
#   verify_done            (final summary print)
#
# Each per-category verifier just lists `run_task TASK_ID 'cmd'`
# lines, with the canonical shell/cerebellum invocation as $2. The
# library handles setup.sh + eval.sh + teardown.sh + timing + tally.

set -u
TASKS_DIR=${TASKS_DIR:-/Users/jackysun/Documents/Workspace/macbench/tasks}
CEREB=${CEREB:-/Users/jackysun/Documents/Workspace/kinclaw/skills/cerebellum/cerebellum.sh}

PASS=0
FAIL=0
SKIP=0
# Bash 3.2: parallel arrays instead of associative
FAIL_IDS=()
FAIL_REASONS=()
SKIP_IDS=()
SKIP_REASONS=()
T0=$(/bin/date +%s)

run_task() {
  local tid="$1"
  local action="${2:-}"
  local task_dir="$TASKS_DIR/$tid"
  if [ ! -d "$task_dir" ]; then
    printf "  ⚠ %s  no task dir — SKIPPED\n" "$tid"
    SKIP=$((SKIP + 1))
    SKIP_IDS+=("$tid")
    SKIP_REASONS+=("no task dir")
    return
  fi
  if [ "$action" = "SKIP_IMPOSSIBLE" ]; then
    printf "  ⊘ %s  marked impossible (TCC / no scriptable path)\n" "$tid"
    SKIP=$((SKIP + 1))
    SKIP_IDS+=("$tid")
    SKIP_REASONS+=("impossible per design")
    return
  fi

  local t_start
  t_start=$(/bin/date +%s%N)

  # setup
  if [ -x "$task_dir/setup.sh" ]; then
    "$task_dir/setup.sh" >/dev/null 2>&1
  fi

  # canonical action (run as eval so $(date ...) etc. inside actions resolve)
  if [ -n "$action" ]; then
    eval "$action" >/dev/null 2>&1
  fi

  # eval
  local eval_rc=0 eval_out=""
  if [ -x "$task_dir/eval.sh" ]; then
    eval_out="$("$task_dir/eval.sh" 2>&1)"
    eval_rc=$?
  fi

  local t_end
  t_end=$(/bin/date +%s%N)
  local dur_ms=$(( (t_end - t_start) / 1000000 ))

  if [ "$eval_rc" -eq 0 ]; then
    PASS=$((PASS + 1))
    printf "  ✓ %s  %dms\n" "$tid" "$dur_ms"
  else
    FAIL=$((FAIL + 1))
    local reason
    reason="$(printf '%s' "$eval_out" | /usr/bin/tail -1)"
    printf "  ✗ %s  %dms  — %s\n" "$tid" "$dur_ms" "$reason"
    FAIL_IDS+=("$tid")
    FAIL_REASONS+=("$reason")
  fi

  # teardown (best-effort, errors ignored)
  if [ -x "$task_dir/teardown.sh" ]; then
    "$task_dir/teardown.sh" >/dev/null 2>&1
  fi
}

verify_done() {
  local label="${1:-tasks}"
  local total=$((PASS + FAIL + SKIP))
  local elapsed=$(( $(/bin/date +%s) - T0 ))
  echo "═══════════════════════════════════════════════════════════════"
  printf "  REFERENCE — %s\n" "$label"
  echo "═══════════════════════════════════════════════════════════════"
  printf "  PASS:   %d / %d\n" "$PASS" "$total"
  printf "  FAIL:   %d / %d\n" "$FAIL" "$total"
  printf "  SKIP:   %d / %d (TCC / no scriptable path)\n" "$SKIP" "$total"
  printf "  TIME:   %ds total\n" "$elapsed"
  if [ "$total" -gt 0 ]; then
    printf "  AVG:    %.2fs per task\n" "$(echo "scale=2; $elapsed / $total" | /usr/bin/bc 2>/dev/null || echo "n/a")"
  fi
  if [ "${#FAIL_IDS[@]}" -gt 0 ]; then
    echo "═══════════════════════════════════════════════════════════════"
    echo "FAILURES:"
    local i=0
    while [ "$i" -lt "${#FAIL_IDS[@]}" ]; do
      printf "  %s → %s\n" "${FAIL_IDS[$i]}" "${FAIL_REASONS[$i]}"
      i=$((i + 1))
    done
  fi
}
