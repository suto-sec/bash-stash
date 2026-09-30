#!/bin/bash
# errscan.sh FILE...: lines matching ERROR or CRITICAL across several files

if [ $# -lt 1 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: cannot read '$f'" >&2
    exit 2
  fi
done

R=$(grep -E 'ERROR|CRITICAL' -- "$@")
[ -n "$R" ] && echo "$R"
if [ -z "$R" ]; then N=0; else N=$(grep -c . <<< "$R"); fi
echo "Total: $N"

