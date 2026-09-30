#!/bin/bash
# copy_pairs.sh SRC DST [SRC DST ...]
if [ $(( $# % 2 )) -ne 0 ]; then
  echo "usage: $(basename "$0") SRC DST [SRC DST ...]" >&2
  exit 1
fi
N=0
while [ $# -gt 0 ]; do
  src=$1
  dst=$2
  shift 2
  if [ ! -e "$src" ]; then
    echo "error: '$src' does not exist" >&2
    exit 2
  fi
  cp "$src" "$dst"
  echo "copiado: $src -> $dst"
  N=$((N + 1))
done
echo "TOTAL: $N copias"

