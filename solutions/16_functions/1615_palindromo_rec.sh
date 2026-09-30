#!/bin/bash
es_palindromo() {
  local s=$1
  local len=${#s}
  if (( len <= 1 )); then return 0; fi
  if [ "${s:0:1}" != "${s: -1}" ]; then return 1; fi
  es_palindromo "${s:1:len-2}"
}
for w in "$@"; do
  if es_palindromo "$w"; then
    echo "$w: palindromo"
  else
    echo "$w: no palindromo"
  fi
done

