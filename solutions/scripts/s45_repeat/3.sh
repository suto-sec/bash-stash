#!/bin/bash
one=
if [[ $1 == -s ]]; then one=1; shift; fi
if (( $# != 2 )); then echo "Error: a word and a count are needed" >&2; echo "Usage: $0 [-s] word N" >&2; exit 1; fi
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 2; }
if [[ -n $one ]]; then
  line=
  for ((i = 0; i < $2; i++)); do line+="${line:+ }$1"; done
  echo "$line"
else
  for ((i = 0; i < $2; i++)); do echo "$1"; done
fi
