#!/bin/bash
es_numero() {
  if [[ $1 =~ ^-?[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}
v=0
i=0
for x in "$@"; do
  if es_numero "$x"; then
    echo "$x: numero"
    v=$((v + 1))
  else
    echo "$x: no numero"
    i=$((i + 1))
  fi
done
echo "total: $v numeros, $i no numeros"

