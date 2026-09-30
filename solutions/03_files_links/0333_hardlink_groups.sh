#!/bin/bash
declare -A seen
n=0
for f in almacen/*; do
  [ -L "$f" ] && continue
  name=$(basename "$f")
  [ -n "${seen[$name]}" ] && continue
  seen[$name]=1
  group=("$name")
  for g in almacen/*; do
    [ -L "$g" ] && continue
    gname=$(basename "$g")
    [ -n "${seen[$gname]}" ] && continue
    if [ "$g" -ef "$f" ]; then
      group+=("$gname")
      seen[$gname]=1
    fi
  done
  if [ "${#group[@]}" -gt 1 ]; then
    echo "${group[*]}"
    n=$((n + 1))
  fi
done
echo "Groups: $n"

