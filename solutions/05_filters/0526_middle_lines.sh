#!/bin/bash
n=$(wc -l < "$1")
if (( n == 0 )); then
  exit 0
elif (( n % 2 == 1 )); then
  head -n $(( (n + 1) / 2 )) "$1" | tail -n 1
else
  head -n $(( n / 2 + 1 )) "$1" | tail -n 2
fi

