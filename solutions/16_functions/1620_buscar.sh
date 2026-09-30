#!/bin/bash
# buscar.sh PATTERN FILE...
if [ $# -lt 2 ]; then
  echo "usage: $(basename "$0") PATTERN FILE..." >&2
  exit 1
fi
PATTERN=$1
shift
if [ -z "$PATTERN" ]; then
  echo "error: empty pattern" >&2
  exit 2
fi

contar() {
  local n
  n=$(grep -c -- "$PATTERN" "$1")
  echo "$n"
}

procesar() {
  local f total=0 valid=0 c
  for f in "$@"; do
    if [ ! -f "$f" ] || [ ! -r "$f" ]; then
      echo "buscar.sh: '$f' no accesible" >&2
      continue
    fi
    c=$(contar "$f")
    echo "$f: $c"
    total=$((total + c))
    valid=$((valid + 1))
  done
  echo "TOTAL: $total matches across $valid files"
}

procesar "$@"

