#!/bin/bash
if (( $# < 1 || $# > 2 )); then
  echo "Error: one or two numbers are needed" >&2
  echo "Usage: $0 N [MAX]" >&2
  exit 1
fi
max=${2:-10}
if [[ ! $1 =~ ^[0-9]+$ ]]; then echo "Error: '$1' is not a non-negative integer" >&2; exit 2; fi
if [[ ! $max =~ ^[1-9][0-9]*$ ]]; then echo "Error: '$max' is not a positive integer" >&2; exit 2; fi
for ((i = 1; i <= max; i++)); do
  echo "$1 x $i = $(($1 * i))"
done
