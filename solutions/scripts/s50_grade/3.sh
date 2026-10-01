#!/bin/bash
if (( $# == 0 )); then echo "Error: at least one score is needed" >&2; echo "Usage: $0 score..." >&2; exit 1; fi
for s in "$@"; do
  if [[ ! $s =~ ^[0-9]+$ ]] || (( s > 100 )); then echo "Error: '$s' is not a score from 0 to 100" >&2; exit 2; fi
done
sum=0
for s in "$@"; do
  if (( s >= 90 )); then g=A; elif (( s >= 80 )); then g=B; elif (( s >= 70 )); then g=C; elif (( s >= 60 )); then g=D; else g=F; fi
  echo "$s: $g"
  sum=$((sum + s))
done
echo "Average: $((sum / $#))"
