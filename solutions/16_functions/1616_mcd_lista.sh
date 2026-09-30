#!/bin/bash
mcd() {
  local a=$1 b=$2
  if [ "$b" -eq 0 ]; then
    echo "$a"
  else
    echo "$(mcd "$b" "$((a % b))")"
  fi
}
r=$1
shift
for x in "$@"; do
  r=$(mcd "$r" "$x")
done
echo "mcd = $r"

