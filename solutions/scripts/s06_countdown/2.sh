#!/bin/bash
if (( $# != 1 )); then
  echo "Error: exactly one number is needed" >&2
  echo "Usage: $0 N" >&2
  exit 1
fi
if [[ ! $1 =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$1' is not a positive integer" >&2
  exit 2
fi
n=$1
while (( n > 0 )); do
  echo "$n"
  n=$((n - 1))
done
echo "Liftoff!"
