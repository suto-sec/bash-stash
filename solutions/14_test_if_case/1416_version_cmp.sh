#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") v1 v2" >&2
  exit 1
fi
for v in "$@"; do
  if [[ ! $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version: $v" >&2
    exit 2
  fi
done
IFS=. read -r a1 a2 a3 <<< "$1"
IFS=. read -r b1 b2 b3 <<< "$2"
r="="
if [ "$a1" -ne "$b1" ]; then
  [ "$a1" -lt "$b1" ] && r="<" || r=">"
elif [ "$a2" -ne "$b2" ]; then
  [ "$a2" -lt "$b2" ] && r="<" || r=">"
elif [ "$a3" -ne "$b3" ]; then
  [ "$a3" -lt "$b3" ] && r="<" || r=">"
fi
echo "$1 $r $2"

