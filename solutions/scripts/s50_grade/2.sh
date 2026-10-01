#!/bin/bash
if (( $# != 1 )); then echo "Error: one score is needed" >&2; echo "Usage: $0 score" >&2; exit 1; fi
if [[ ! $1 =~ ^[0-9]+$ ]] || (( $1 > 100 )); then echo "Error: '$1' is not a score from 0 to 100" >&2; exit 2; fi
s=$1
if (( s >= 90 )); then echo A
elif (( s >= 80 )); then echo B
elif (( s >= 70 )); then echo C
elif (( s >= 60 )); then echo D
else echo F
fi
