#!/bin/bash
if (( $# != 2 )); then echo "Error: two files are needed" >&2; echo "Usage: $0 a.csv b.csv" >&2; exit 1; fi
for f in "$1" "$2"; do
  [[ -f $f && -r $f && -s $f ]] || { echo "Error: cannot use $f" >&2; exit 2; }
done
if [[ $(head -n 1 "$1") != "$(head -n 1 "$2")" ]]; then echo "Error: the headers differ" >&2; exit 4; fi
head -n 1 "$1"
tail -n +2 "$1"
tail -n +2 "$2"
