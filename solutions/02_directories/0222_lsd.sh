#!/bin/bash
# lsd.sh [-a] DIR... - lists several directories
OPT=
if [ "$1" = -a ]; then
  OPT=-A
  shift
fi
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") [-a] DIR..." >&2
  exit 1
fi
N=0 E=0
for d in "$@"; do
  if [ ! -d "$d" ]; then
    echo "lsd.sh: cannot list '$d'" >&2
    E=$((E + 1))
    continue
  fi
  echo "$d:"
  LIST=$(ls -p $OPT "$d")
  if [ -n "$LIST" ]; then
    echo "$LIST" | sed 's/^/  /'
    DIRS=$(echo "$LIST" | grep -c '/$')
    ALL=$(echo "$LIST" | wc -l)
  else
    DIRS=0 ALL=0
  fi
  echo "  ($DIRS dirs, $((ALL - DIRS)) other)"
  N=$((N + 1))
done
echo "Listed $N directories, $E errors"
[ "$E" -eq 0 ] || exit 2

