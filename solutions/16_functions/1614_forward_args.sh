#!/bin/bash
contar() {
  echo "$# args:"
  local v
  for v in "$@"; do
    echo "- '$v' (${#v} chars)"
  done
}
mostrar() {
  contar "$@"
}
mostrar "$@"

