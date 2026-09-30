#!/bin/bash
K=0
parada=
for c in "$@"; do
  K=$((K + 1))
  if [ "$c" -eq 0 ]; then
    echo "paso $K: $c (ok)"
  else
    echo "paso $K: $c (fallo)"
    parada=$K
    break
  fi
done
if [ -n "$parada" ]; then
  echo "detenido en paso $parada"
else
  echo "todo ok"
fi
echo "pasos_ejecutados: $K"

