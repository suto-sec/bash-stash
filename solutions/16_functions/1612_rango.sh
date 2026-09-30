#!/bin/bash
rango() {
  local menor=$1 mayor=$1 x
  for x in "$@"; do
    [ "$x" -lt "$menor" ] && menor=$x
    [ "$x" -gt "$mayor" ] && mayor=$x
  done
  echo "$menor $mayor"
}
read -r menor mayor <<< "$(rango "$@")"
echo "menor=$menor mayor=$mayor"

