#!/bin/bash
while IFS= read -r d; do
  [[ -f $d/$1 && -x $d/$1 ]] && echo "$d/$1"
done < <(echo "$2" | tr ':' '\n')
exit 0
