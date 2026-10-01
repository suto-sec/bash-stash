#!/bin/bash
if (( $# != 2 )); then echo "Error: a prefix and a count are needed" >&2; echo "Usage: $0 prefix N" >&2; exit 1; fi
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 2; }
if [[ -z $1 || $1 == */* ]]; then echo "Error: bad prefix '$1'" >&2; exit 3; fi
for ((i = 1; i <= $2; i++)); do
  touch -- "$1$i"
done
echo "Created $2 files"
