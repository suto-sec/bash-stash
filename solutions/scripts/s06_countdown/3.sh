#!/bin/bash
if (( $# < 1 || $# > 2 )); then
  echo "Error: one or two numbers are needed" >&2
  echo "Usage: $0 N [STEP]" >&2
  exit 1
fi
step=${2:-1}
for v in "$1" "$step"; do
  if [[ ! $v =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: '$v' is not a positive integer" >&2
    exit 2
  fi
done
n=$1
while (( n > 0 )); do
  echo "$n"
  n=$((n - step))
done
echo "Liftoff!"
