#!/bin/bash
if (( $# == 0 )); then echo "Error: at least one directory is needed" >&2; echo "Usage: $0 dir..." >&2; exit 1; fi
bad=0
for d in "$@"; do
  if [[ ! -d $d ]]; then echo "Error: $d is not a directory" >&2; bad=1; continue; fi
  echo "$d: $(ls -A "$d" | wc -l) entries"
done
(( bad == 0 )) || exit 2
