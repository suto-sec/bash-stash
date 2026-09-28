#!/bin/bash
maximo() {
  local m=$1 x
  for x in "$@"; do [ "$x" -gt "$m" ] && m=$x; done
  echo "$m"
}
media() {
  local s=0 x
  for x in "$@"; do s=$((s + x)); done
  echo $((s / $#))
}
echo "max=$(maximo "$@") avg=$(media "$@")"

