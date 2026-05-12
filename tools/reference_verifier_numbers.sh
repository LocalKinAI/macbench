#!/bin/bash
# Reference verifier for macbench numbers (15 tasks).
# Numbers AppleScript supports cells/formulas well; formatting (fill,
# currency, sort, filter, pivot) is soft-pass UI-only.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — numbers (15 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 028: new doc + set A1=42 + save
run_task "028-numbers-create-sheet" \
  "$CEREB \"numbers new $HOME/Desktop/kinbench/028-sheet.numbers\"; \
   $CEREB \"numbers set_cell $HOME/Desktop/kinbench/028-sheet.numbers 'Sheet 1' A1 42\""

# 312: bold A1
run_task "312-numbers-bold-cell" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/312-sheet.numbers\"; \
   $CEREB \"numbers bold_cell $HOME/Desktop/kinbench/312-sheet.numbers 'Sheet 1' A1\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/312-bold-confirm.txt"

# 313: fill A1 yellow
run_task "313-numbers-fill-color" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/313-sheet.numbers\"; \
   $CEREB \"numbers fill_color $HOME/Desktop/kinbench/313-sheet.numbers 'Sheet 1' A1 yellow\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/313-fill-confirm.txt"

# 314: =SUM(A1:A5) in A6
run_task "314-numbers-create-formula" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/314-sheet.numbers\"; \
   $CEREB \"numbers create_formula $HOME/Desktop/kinbench/314-sheet.numbers 'Sheet 1' A6 '=SUM(A1:A5)'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/314-formula-confirm.txt"

# 315: add row
run_task "315-numbers-add-row" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/315-sheet.numbers\"; \
   $CEREB \"numbers add_row $HOME/Desktop/kinbench/315-sheet.numbers 'Sheet 1'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/315-row-confirm.txt"

# 316: add column
run_task "316-numbers-add-column" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/316-sheet.numbers\"; \
   $CEREB \"numbers add_column $HOME/Desktop/kinbench/316-sheet.numbers 'Sheet 1'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/316-col-confirm.txt"

# 317: currency format column A
run_task "317-numbers-format-currency" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/317-sheet.numbers\"; \
   $CEREB \"numbers format_currency $HOME/Desktop/kinbench/317-sheet.numbers 'Sheet 1' A1:A20\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/317-currency-confirm.txt"

# 318: insert bar chart
run_task "318-numbers-add-chart" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/318-sheet.numbers\"; \
   $CEREB \"numbers add_chart $HOME/Desktop/kinbench/318-sheet.numbers 'Sheet 1' A1:B10 bar\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/318-chart-confirm.txt"

# 319: sort by column A
run_task "319-numbers-sort-data" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/319-sheet.numbers\"; \
   $CEREB \"numbers sort_data $HOME/Desktop/kinbench/319-sheet.numbers 'Sheet 1' A1:Z100 A\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/319-sort-confirm.txt"

# 320: filter A>100
run_task "320-numbers-filter-rows" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/320-sheet.numbers\"; \
   $CEREB \"numbers filter_rows $HOME/Desktop/kinbench/320-sheet.numbers 'Sheet 1' 'A>100'\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/320-filter-confirm.txt"

# 321: merge A1:B1
run_task "321-numbers-merge-cells" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/321-sheet.numbers\"; \
   $CEREB \"numbers merge_cells $HOME/Desktop/kinbench/321-sheet.numbers 'Sheet 1' A1:B1\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/321-merge-confirm.txt"

# 322: freeze header row
run_task "322-numbers-freeze-row" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/322-sheet.numbers\"; \
   $CEREB \"numbers freeze_row $HOME/Desktop/kinbench/322-sheet.numbers 'Sheet 1' 1\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/322-freeze-confirm.txt"

# 323: import CSV → save as .numbers
run_task "323-numbers-import-csv" \
  "$CEREB \"numbers import_csv $HOME/Desktop/kinbench/323-data.csv $HOME/Desktop/kinbench/323-imported.numbers\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/323-csv-confirm.txt"

# 324: pivot aggregate (UI-only Organize > Pivot; soft-pass)
run_task "324-numbers-pivot-aggregate" \
  "$CEREB \"numbers open $HOME/Desktop/kinbench/324-sheet.numbers\"; \
   $CEREB \"numbers pivot_aggregate $HOME/Desktop/kinbench/324-sheet.numbers 'Sheet 1' A1:B100\"; \
   /bin/echo 'done' > $HOME/Desktop/kinbench/324-pivot-confirm.txt"

# 325: export PDF
run_task "325-numbers-export-pdf" \
  "$CEREB \"numbers save_as_pdf $HOME/Desktop/kinbench/325-sheet.numbers $HOME/Desktop/kinbench/325-sheet.pdf\""

verify_done "numbers"
