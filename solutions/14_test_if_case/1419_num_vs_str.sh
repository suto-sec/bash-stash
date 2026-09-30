#!/bin/bash
if [ $# -ne 2 ] || [[ ! $1 =~ ^[0-9]+$ || ! $2 =~ ^[0-9]+$ ]]; then
  echo "Usage: $(basename "$0") a b" >&2
  exit 1
fi
if [ "$1" -lt "$2" ]; then n="<"
elif [ "$1" -gt "$2" ]; then n=">"
else n="="
fi
if [[ $1 < $2 ]]; then s="<"
elif [[ $1 > $2 ]]; then s=">"
else s="="
fi
echo "numeric: $1 $n $2"
echo "string: $1 $s $2"

