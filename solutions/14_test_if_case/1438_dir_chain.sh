#!/bin/bash
# dir_chain.sh NAME1 [NAME2 ...]
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") NAME1 [NAME2 ...]" >&2
  exit 1
fi
path=
for n in "$@"; do
  if [ -z "$path" ]; then path=$n; else path="$path/$n"; fi
  if [ ! -d "$path" ]; then
    echo "error: '$path' is not a directory" >&2
    exit 2
  fi
done
echo "cadena valida: $path"

