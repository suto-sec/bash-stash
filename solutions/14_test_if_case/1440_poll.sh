#!/bin/bash
S=0; N=0; I=0
while read -r v; do
  case ${v,,} in
    si) echo "voto: si"; S=$((S + 1)) ;;
    no) echo "voto: no"; N=$((N + 1)) ;;
    *) echo "voto: invalido"; I=$((I + 1)) ;;
  esac
done
echo "si: $S"
echo "no: $N"
echo "invalido: $I"
if [ "$S" -gt "$N" ]; then echo "ganador: si"
elif [ "$N" -gt "$S" ]; then echo "ganador: no"
else echo "empate"
fi

