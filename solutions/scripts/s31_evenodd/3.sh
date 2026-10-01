#!/bin/bash
if (( $# == 0 )); then echo "Error: at least one number is needed" >&2; echo "Usage: $0 N..." >&2; exit 1; fi
for n in "$@"; do
  [[ $n =~ ^[0-9]+$ ]] || { echo "Error: '$n' is not a non-negative integer" >&2; exit 2; }
done
even=0 odd=0
for n in "$@"; do
  if (( n % 2 == 0 )); then echo "$n is even"; even=$((even + 1)); else echo "$n is odd"; odd=$((odd + 1)); fi
done
echo "even: $even, odd: $odd"
