#!/usr/bin/env bash
# Post-bench cleanup. Removes all KinBench-prefixed data that the bench
# leaves behind across Notes / Reminders / Calendar / Mail Drafts and
# wipes the sandbox dirs. Force-quits the apps that the bench touched
# so the user's workspace returns to a clean state.
#
# Idempotent — safe to run multiple times. Best-effort: failures (TCC
# denied, app hung) are swallowed and reported; we never block on a
# single uncooperative app.
#
# Usage:
#   tools/cleanup.sh           # quiet mode (just one-line summaries)
#   VERBOSE=1 tools/cleanup.sh # show each deletion
#
# Hook this from `make bench` after the runner exits so users don't
# accumulate cruft between runs.

set -uo pipefail
VERBOSE="${VERBOSE:-0}"
OK="✓"
WARN="⚠"

clean_with_timeout() {
  local label="$1" script="$2" t="${3:-15}"
  local out
  out=$(/opt/homebrew/bin/timeout "$t" /usr/bin/osascript -e "$script" 2>&1)
  local code=$?
  if [[ $code -eq 0 ]]; then
    [[ "$VERBOSE" == "1" ]] && printf "  %s %s — %s\n" "$OK" "$label" "$out" \
      || printf "  %s %s\n" "$OK" "$label"
  elif [[ $code -eq 124 ]]; then
    printf "  %s %s — TIMED OUT after %ss\n" "$WARN" "$label" "$t"
  else
    printf "  %s %s — err: %s\n" "$WARN" "$label" "$(printf '%s' "$out" | /usr/bin/head -1)"
  fi
}

echo "═══════════════════════════════════════════════════════════════"
echo "  macbench cleanup — post-run garbage collection"
echo "═══════════════════════════════════════════════════════════════"

# ─── 1. Optionally force-quit bench-touched apps ────────────────────
# Default: LEAVE APPS OPEN — they belong to the user. We only purge
# KinBench-prefixed *data inside* them. Set KILL_APPS=1 to force-quit
# (useful right before another bench run, when warmup needs a clean
# slate). Apps the bench opened on its own but the user didn't ask
# for (iWork suite, System Settings) are always closed — they're
# bench artifacts.
echo "[1/4] handling apps…"
ALWAYS_CLOSE="TextEdit Pages Numbers Keynote 'System Settings' 'System Preferences'"
USER_APPS="Safari Mail Notes Reminders Calendar Music Photos Maps"
for app in $ALWAYS_CLOSE; do
  app_unquoted="$(/bin/echo "$app" | /usr/bin/tr -d "'")"
  if /usr/bin/pgrep -x "$app_unquoted" >/dev/null 2>&1; then
    /usr/bin/killall "$app_unquoted" 2>/dev/null && printf "  %s closed bench-only app: %s\n" "$OK" "$app_unquoted" || true
  fi
done
if [ "${KILL_APPS:-0}" = "1" ]; then
  for app in $USER_APPS; do
    if /usr/bin/pgrep -x "$app" >/dev/null 2>&1; then
      /usr/bin/killall "$app" 2>/dev/null && printf "  %s closed user app: %s (KILL_APPS=1)\n" "$OK" "$app" || true
    fi
  done
  /bin/sleep 1
else
  printf "  %s leaving user apps (Safari/Mail/Notes/Reminders/Calendar/Music/Photos/Maps) running\n" "$OK"
  printf "      pass KILL_APPS=1 to force-quit them\n"
fi

# ─── 2. Clear KinBench-prefixed data inside app stores ──────────────
echo "[2/4] purging KinBench-prefixed app data…"

clean_with_timeout "Notes (prefix=KinBench)" '
tell application "Notes"
    set killed to 0
    repeat with acct in accounts
        repeat with f in folders of acct
            try
                if (name of f as string) is not "Recently Deleted" then
                    repeat with n in (every note of f whose name starts with "KinBench")
                        try
                            delete n
                            set killed to killed + 1
                        end try
                    end repeat
                end if
            end try
        end repeat
    end repeat
    return "deleted " & killed
end tell' 30

clean_with_timeout "Reminders (prefix=KinBench)" '
tell application "Reminders"
    set killed to 0
    repeat 3 times
        repeat with l in lists
            try
                repeat with r in (every reminder of l whose name starts with "KinBench")
                    try
                        delete r
                        set killed to killed + 1
                    end try
                end repeat
            end try
        end repeat
    end repeat
    repeat with l in lists
        try
            if (name of l) starts with "KinBench" or (name of l) starts with "kinbench-" then
                delete l
                set killed to killed + 1
            end if
        end try
    end repeat
    return "deleted " & killed
end tell' 120

clean_with_timeout "Calendar (prefix=KinBench, 3 passes)" '
tell application "Calendar"
    set killed to 0
    -- Multi-pass — iCloud sometimes re-pushes between passes
    repeat 3 times
        repeat with c in calendars
            try
                repeat with ev in (every event of c whose summary contains "KinBench")
                    try
                        try
                            set recurrence of ev to ""
                        end try
                        delete ev
                        set killed to killed + 1
                    end try
                end repeat
            end try
        end repeat
        delay 1
    end repeat
    -- Also nuke the synthetic "KinBench Calendar" itself
    try
        delete (first calendar whose name is "KinBench Calendar")
    end try
    return "deleted " & killed
end tell' 180

clean_with_timeout "Mail Drafts (prefix=KinBench)" '
tell application "Mail"
    set killed to 0
    repeat with a in accounts
        try
            repeat with m in (every message of (mailbox "Drafts" of a) whose subject starts with "KinBench")
                try
                    delete m
                    set killed to killed + 1
                end try
            end repeat
        end try
    end repeat
    return "deleted " & killed
end tell' 30

# ─── 3. Wipe sandbox dirs ───────────────────────────────────────────
echo "[3/4] wiping sandbox dirs…"
SANDBOX1="$HOME/Desktop/kinbench"
SANDBOX2="$HOME/.kinbench"
for d in "$SANDBOX1" "$SANDBOX2"; do
  if [ -d "$d" ]; then
    n=$(/usr/bin/find "$d" -type f 2>/dev/null | /usr/bin/wc -l | /usr/bin/tr -d ' ')
    /bin/rm -rf "$d"
    printf "  %s removed %s (%d files)\n" "$OK" "$d" "$n"
  fi
done

# Stray /tmp/multi-* and /tmp/cal_pdf* etc.
strays=$(/usr/bin/find /tmp -maxdepth 1 -name 'multi-*' -o -name 'cal_pdf*' -o -name 'hhmm-test*' 2>/dev/null | /usr/bin/wc -l | /usr/bin/tr -d ' ')
if [ "$strays" != "0" ]; then
  /usr/bin/find /tmp -maxdepth 1 \( -name 'multi-*' -o -name 'cal_pdf*' -o -name 'hhmm-test*' \) -exec /bin/rm -rf {} \; 2>/dev/null
  printf "  %s removed %d stray /tmp/multi-*/cal_pdf*/hhmm-test* artifacts\n" "$OK" "$strays"
fi

# ─── 4. Verify (don't re-kill user apps) ─────────────────────────────
echo "[4/4] verifying clean state…"
# Always re-close the bench-only apps if they came back during cleanup.
for app in TextEdit Pages Numbers Keynote "System Settings" "System Preferences"; do
  if /usr/bin/pgrep -x "$app" >/dev/null 2>&1; then
    /usr/bin/killall "$app" 2>/dev/null && printf "  %s re-closed bench-only %s\n" "$OK" "$app" || true
  fi
done
# Only re-close user apps if KILL_APPS=1.
if [ "${KILL_APPS:-0}" = "1" ]; then
  for app in Safari Mail Notes Reminders Calendar Music Photos Maps; do
    if /usr/bin/pgrep -x "$app" >/dev/null 2>&1; then
      /usr/bin/killall "$app" 2>/dev/null && printf "  %s re-closed user app %s\n" "$OK" "$app" || true
    fi
  done
fi

# Tally remaining KinBench items
remaining=0
for q in 'tell application "Notes" to count notes whose name starts with "KinBench"' \
         'tell application "Reminders" to count reminders whose name starts with "KinBench"' \
         'tell application "Calendar"
            set t to 0
            repeat with c in calendars
              try
                set t to t + (count of (every event of c whose summary contains "KinBench"))
              end try
            end repeat
            return t
          end tell' ; do
  v=$(/opt/homebrew/bin/timeout 8 /usr/bin/osascript -e "$q" 2>/dev/null)
  if [ -n "$v" ]; then
    remaining=$((remaining + v))
  fi
done

echo "═══════════════════════════════════════════════════════════════"
if [ "$remaining" = "0" ] && [ ! -d "$SANDBOX1" ] && [ ! -d "$SANDBOX2" ]; then
  echo "  $OK clean state restored (0 KinBench items, 0 sandbox files)"
else
  echo "  $WARN $remaining stragglers remain (likely iCloud-resistant recurring events — see calendar.app)"
fi
echo "═══════════════════════════════════════════════════════════════"
