#!/bin/bash
if (( $# != 3 )); then echo "Error: three arguments needed" >&2; echo "Usage: $0 a op b" >&2; exit 1; fi
re='^-?[0-9]+$'
[[ $1 =~ $re ]] || { echo "Error: $1 is not an integer" >&2; exit 2; }
[[ $3 =~ $re ]] || { echo "Error: $3 is not an integer" >&2; exit 2; }
case $2 in
  +) r=$(( $1 + $3 )) ;;
  -) r=$(( $1 - $3 )) ;;
  x) r=$(( $1 * $3 )) ;;
  /|%) (( $3 != 0 )) || { echo "Error: division by zero" >&2; exit 4; }
     if [[ $2 == / ]]; then r=$(( $1 / $3 )); else r=$(( $1 % $3 )); fi ;;
  *) echo "Error: unknown operator $2" >&2; exit 3 ;;
esac
echo "$1 $2 $3 = $r"
