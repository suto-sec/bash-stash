#!/bin/bash
n="sin datos"
progreso() {
  local n=1
  local v
  for v in "$@"; do
    echo "paso $n: valor $v"
    n=$((n + 1))
  done
}
sumar() {
  local s=0 x
  for x in "$@"; do s=$((s + x)); done
  echo "$s"
}
echo "estado antes: $n"
progreso "$@"
echo "estado despues: $n"
echo "total: $(sumar "$@")"

