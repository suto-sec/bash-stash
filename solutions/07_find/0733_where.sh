#!/bin/bash
# where.sh PATTERN DIR... - find files by name pattern in several directories
if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") PATTERN DIR..." >&2
  exit 2
fi
PAT=$1
shift

TOTAL=0
VALID=0
BAD=0
for d in "$@"; do
  if [ ! -d "$d" ]; then
    echo "Error: '$d' is not a directory" >&2
    BAD=1
    continue
  fi
  VALID=$((VALID + 1))
  echo "== $d =="
  R=$(find "$d" -type f -name "$PAT" | sort)
  if [ -z "$R" ]; then
    echo "(no matches)"
  else
    echo "$R"
    TOTAL=$((TOTAL + $(echo "$R" | wc -l)))
  fi
done
echo "$TOTAL matches in $VALID directories"

[ $BAD -eq 1 ] && exit 3
[ $TOTAL -eq 0 ] && exit 1
exit 0

