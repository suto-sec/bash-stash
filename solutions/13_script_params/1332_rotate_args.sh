#!/bin/bash
K=$1
shift
if [ $# -eq 0 ]; then
  echo "Error: no hay elementos" >&2
  exit 1
fi
if ! [[ $K =~ ^[0-9]+$ ]]; then
  echo "Error: K invalido" >&2
  exit 2
fi
K=$((K % $#))
i=0
while [ "$i" -lt "$K" ]; do
  first=$1
  shift
  set -- "$@" "$first"
  i=$((i + 1))
done
for a in "$@"; do echo "$a"; done

