#!/bin/bash
echo "Nombre del script: $0"
echo "Se han recibido $# argumentos"
echo "Los argumentos son (\$*): $*"
echo "Los argumentos son (\$@): $@"
i=1
for p in "$@"
do
  echo "Argumento $i: $p"
  i=$((i+1))
done
