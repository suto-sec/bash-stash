#!/bin/bash
source ./lib_texto.sh
for w in "$@"; do
  v=$(contar_vocales "$w")
  if es_largo "$w" 5; then
    echo "$w: $v vocales, largo"
  else
    echo "$w: $v vocales, corto"
  fi
done

