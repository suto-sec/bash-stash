#!/bin/bash
n=0
parada=
while read -r nombre estado; do
  case $estado in
    hecho) continue ;;
    fallo) echo "parada en: $nombre"; parada=1; break ;;
    pendiente) echo "procesando: $nombre"; n=$((n + 1)) ;;
  esac
done < tareas.txt
[ -z "$parada" ] && echo "todo ok"
echo "procesadas: $n"

