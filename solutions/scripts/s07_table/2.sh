#!/bin/bash
if (( $# != 1 )); then
  echo "Error: exactly one number is needed" >&2
  echo "Usage: $0 N" >&2
  exit 1
fi
if [[ ! $1 =~ ^[0-9]+$ ]]; then
  echo "Error: '$1' is not a non-negative integer" >&2
  exit 2
fi
for i in {1..10}; do
  echo "$1 x $i = $(($1 * i))"
done
