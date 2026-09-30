#!/bin/bash
quiet=0
if [ "$1" = "-q" ]; then
  quiet=1
  shift
fi
if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") [-q] word file..." >&2
  exit 2
fi
word=$1
shift
status=1
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "cannot read: $f" >&2
    continue
  fi
  n=$(grep -cF -- "$word" "$f")
  [ "$n" -gt 0 ] && status=0
  [ $quiet -eq 0 ] && echo "$f: $n"
done
exit $status

