#!/bin/bash
fact() {
  if [ "$1" -le 1 ]; then echo 1; else echo $(( $1 * $(fact $(( $1 - 1 ))) )); fi
}
hanoi() {
  local n=$1 from=$2 to=$3 via=$4
  [ "$n" -eq 0 ] && return
  hanoi $((n - 1)) "$from" "$via" "$to"
  echo "move disk $n from $from to $to"
  hanoi $((n - 1)) "$via" "$to" "$from"
}
echo "$1! = $(fact "$1")"
hanoi "$1" A C B

