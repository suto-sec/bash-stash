#!/bin/bash
if (( $# != 1 )); then echo "Error: one number is needed" >&2; echo "Usage: $0 N" >&2; exit 1; fi
[[ $1 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$1' is not a positive integer" >&2; exit 2; }
for ((i = 1; i <= $1; i++)); do
  if (( i % 15 == 0 )); then echo FizzBuzz
  elif (( i % 3 == 0 )); then echo Fizz
  elif (( i % 5 == 0 )); then echo Buzz
  else echo "$i"
  fi
done
