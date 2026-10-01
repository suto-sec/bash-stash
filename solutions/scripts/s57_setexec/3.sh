#!/bin/bash
who=u
if [[ $1 == -a ]]; then who=a; shift; fi
if (( $# == 0 )); then echo "Error: at least one file is needed" >&2; echo "Usage: $0 [-a] file..." >&2; exit 1; fi
bad=0
for f in "$@"; do
  if [[ ! -f $f ]]; then echo "skipped $f" >&2; bad=1; continue; fi
  chmod "$who+x" -- "$f"
  echo "ok $f"
done
(( bad == 0 )) || exit 2
