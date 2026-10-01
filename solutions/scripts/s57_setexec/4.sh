#!/bin/bash
who=u
if [[ $1 == -a ]]; then who=a; shift; fi
if (( $# == 0 )); then echo "Error: at least one file is needed" >&2; echo "Usage: $0 [-a] file..." >&2; exit 1; fi
bad=0 n=0
for f in "$@"; do
  if [[ ! -f $f ]]; then echo "skipped $f" >&2; bad=1; continue; fi
  mode=$(stat -c %a "$f")
  if [[ $who == a ]]; then
    if (( (mode & 0111) == 0111 )); then echo "unchanged $f"; continue; fi
  else
    if (( mode & 0100 )); then echo "unchanged $f"; continue; fi
  fi
  chmod "$who+x" -- "$f"
  echo "ok $f"; n=$((n + 1))
done
echo "Changed $n files"
(( bad == 0 )) || exit 2
