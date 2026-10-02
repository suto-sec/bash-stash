#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 name [list]" >&2; exit 1; fi
list=${2:-$PATH}
while IFS= read -r d; do
  [[ -f $d/$1 && -x $d/$1 ]] && echo "$d/$1"
done < <(echo "$list" | tr ':' '\n')
exit 0
