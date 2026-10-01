#!/bin/bash
if (( $# != 2 )); then echo "Error: a word and a count are needed" >&2; echo "Usage: $0 word N" >&2; exit 1; fi
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 2; }
for ((i = 0; i < $2; i++)); do
  echo "$1"
done
