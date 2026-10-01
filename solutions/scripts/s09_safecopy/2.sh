#!/bin/bash
if (( $# != 2 )); then
  echo "Error: two arguments are needed" >&2
  echo "Usage: $0 source dest" >&2
  exit 1
fi
if [[ ! -f $1 ]]; then echo "Error: $1 is not a regular file" >&2; exit 2; fi
cp -- "$1" "$2"
echo "Copied $1 to $2"
