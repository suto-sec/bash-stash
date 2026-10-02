#!/bin/bash
if (( $# < 2 || $# > 3 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file key [default]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
if line=$(grep -v '^#' "$1" | grep "^$2=" | tail -n 1); then
  echo "$line" | cut -d= -f2-
elif (( $# == 3 )); then
  echo "$3"
else
  echo "Error: key $2 not found in $1" >&2; exit 4
fi
