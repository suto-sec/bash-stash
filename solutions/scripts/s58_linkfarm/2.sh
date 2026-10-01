#!/bin/bash
if [[ ! -d $2 ]]; then mkdir -p "$2"; echo "Directory $2 created"; fi
for f in "$1"/*; do
  [[ -f $f ]] || continue
  ln -s "$(readlink -f "$f")" "$2/$(basename "$f")"
  echo "linked $(basename "$f")"
done
exit 0
