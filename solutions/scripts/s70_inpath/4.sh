#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 name [list]" >&2; exit 1; fi
list=${2:-$PATH}
n=0
while IFS= read -r d; do
  if [[ -f $d/$1 && -x $d/$1 ]]; then echo "$d/$1"; n=$((n + 1)); fi
done < <(echo "$list" | tr ':' '\n')
if (( n == 0 )); then echo "$1 not found" >&2; exit 2; fi
echo "Found $n times"
