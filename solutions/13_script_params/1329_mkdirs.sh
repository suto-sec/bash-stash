#!/bin/bash
# mkdirs.sh base count [prefix] - create numbered directories

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $(basename "$0") base count [prefix]" >&2
  exit 1
fi
base=$1 count=$2 prefix=${3-dir}

if [ ! -e "$base" ]; then
  echo "Error: '$base' does not exist" >&2
  exit 2
fi
if [ ! -d "$base" ]; then
  echo "Error: '$base' is not a directory" >&2
  exit 3
fi
if [[ ! $count =~ ^[1-9][0-9]?$ ]]; then
  echo "Error: invalid count '$count' (1-99)" >&2
  exit 4
fi
if [[ ! $prefix =~ ^[A-Za-z_]+$ ]]; then
  echo "Error: invalid prefix '$prefix'" >&2
  exit 5
fi

c=0 e=0
for ((i = 1; i <= count; i++)); do
  p=$base/$(printf '%s%02d' "$prefix" "$i")
  if [ -e "$p" ] || [ -L "$p" ]; then
    echo "exists: $p"
    e=$((e + 1))
  else
    mkdir "$p"
    echo "created: $p"
    c=$((c + 1))
  fi
done
echo "Created $c, existing $e"

