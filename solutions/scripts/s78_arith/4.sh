#!/bin/bash
if (( $# < 3 || $# % 2 == 0 )); then echo "Error: an odd number of arguments (at least 3) is needed" >&2; echo "Usage: $0 a op b [op c ...]" >&2; exit 1; fi
re='^-?[0-9]+$'
[[ $1 =~ $re ]] || { echo "Error: $1 is not an integer" >&2; exit 2; }
acc=$1; expr=$1; shift
while (( $# )); do
  op=$1 n=$2; shift 2
  [[ $n =~ $re ]] || { echo "Error: $n is not an integer" >&2; exit 2; }
  case $op in
    +) acc=$(( acc + n )) ;;
    -) acc=$(( acc - n )) ;;
    x) acc=$(( acc * n )) ;;
    /|%) (( n != 0 )) || { echo "Error: division by zero" >&2; exit 4; }
       if [[ $op == / ]]; then acc=$(( acc / n )); else acc=$(( acc % n )); fi ;;
    *) echo "Error: unknown operator $op" >&2; exit 3 ;;
  esac
  expr="$expr $op $n"
done
echo "$expr = $acc"
