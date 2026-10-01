#!/bin/bash
opt=
if [[ $1 == -i ]]; then opt=-i; shift; fi
if (( $# < 2 )); then echo "Error: a word and a file are needed" >&2; echo "Usage: $0 [-i] word file..." >&2; exit 1; fi
word=$1; shift
bad=0
for f in "$@"; do
  if [[ ! -f $f || ! -r $f ]]; then echo "Error: cannot read $f" >&2; bad=1; continue; fi
  echo "$f: $(grep -c $opt -- "$word" "$f")"
done
(( bad == 0 )) || exit 2
