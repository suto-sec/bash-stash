#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Use: $0 FILE1 FILE2" >&2
  exit 1
fi
for f in "$1" "$2"; do
  if [ ! -e "$f" ]; then
    echo "$0: $f does not exist" >&2
    exit 2
  fi
done
if [ "$1" -nt "$2" ]; then echo "$1"; else echo "$2"; fi
