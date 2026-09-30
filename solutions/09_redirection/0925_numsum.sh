#!/bin/bash
# numsum.sh [FILE]
if [ $# -gt 1 ]; then
  echo "Usage: $(basename "$0") [FILE]" >&2
  exit 1
fi
if [ $# -eq 1 ] && [ "$1" != "-" ]; then
  if [ ! -f "$1" ] || [ ! -r "$1" ]; then
    echo "Error: cannot read '$1'" >&2
    exit 2
  fi
  exec < "$1"      # from now on, stdin is the file
fi

n=0 c=0 s=0 bad=0 min= max=
while IFS= read -r l; do
  n=$((n + 1))
  [ -z "$l" ] && continue
  if [[ $l =~ ^-?(0|[1-9][0-9]*)$ ]]; then
    c=$((c + 1))
    s=$((s + l))
    if [ -z "$min" ] || [ "$l" -lt "$min" ]; then min=$l; fi
    if [ -z "$max" ] || [ "$l" -gt "$max" ]; then max=$l; fi
  else
    echo "line $n: invalid '$l'" >&2
    bad=1
  fi
done
echo "count: $c"
echo "sum: $s"
if [ $c -gt 0 ]; then
  echo "min: $min"
  echo "max: $max"
fi
[ $bad -eq 0 ] || exit 3
