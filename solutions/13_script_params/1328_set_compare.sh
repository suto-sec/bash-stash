#!/bin/bash
# samelines.sh [-q] file1 file2 - compare the sets of lines of two files

quiet=0
if [ "$1" = "-q" ]; then
  quiet=1
  shift
fi
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") [-q] file1 file2" >&2
  exit 2
fi
for f in "$1" "$2"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: '$f' is not a readable regular file" >&2
    exit 3
  fi
done

t1=$(mktemp) t2=$(mktemp)
sort -u "$1" > "$t1"
sort -u "$2" > "$t2"
a=$(grep -cFxv -f "$t2" "$t1")
b=$(grep -cFxv -f "$t1" "$t2")
c=$(grep -cFx -f "$t2" "$t1")
if [ $quiet -eq 0 ]; then
  grep -Fxv -f "$t2" "$t1" | sed 's/^/< /'
  grep -Fxv -f "$t1" "$t2" | sed 's/^/> /'
  echo "Common: $c, only in $1: $a, only in $2: $b"
fi
rm -f "$t1" "$t2"
[ "$a" -eq 0 ] && [ "$b" -eq 0 ] && exit 0
exit 1

