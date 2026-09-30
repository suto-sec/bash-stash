#!/bin/bash
# splitlog.sh LOG OUTDIR
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") LOG OUTDIR" >&2
  exit 1
fi
LOG=$1
OUT=$2
if [ ! -f "$LOG" ] || [ ! -r "$LOG" ]; then
  echo "Error: cannot read '$LOG'" >&2
  exit 2
fi
if [ -e "$OUT" ] && [ ! -d "$OUT" ]; then
  echo "Error: '$OUT' is not a directory" >&2
  exit 3
fi
if [ ! -d "$OUT" ]; then
  mkdir -p "$OUT"
  echo "Created $OUT"
fi

T=0
for L in ERROR WARN INFO DEBUG; do
  RE="^[^ ]+ [^ ]+ $L( |$)"
  n=$(grep -cE "$RE" "$LOG")
  # only redirect when there is something: >> would create an empty file
  [ "$n" -gt 0 ] && grep -E "$RE" "$LOG" >> "$OUT/${L,,}.log"
  echo "${L,,}: $n"
  T=$((T + n))
done
RE='^[^ ]+ [^ ]+ (ERROR|WARN|INFO|DEBUG)( |$)'
n=$(grep -vE "$RE" "$LOG" | grep -c .)
[ "$n" -gt 0 ] && grep -vE "$RE" "$LOG" | grep . >> "$OUT/other.log"
echo "other: $n"
echo "Total: $((T + n)) lines"

