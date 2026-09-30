#!/bin/bash
# balance.sh STRING
if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") STRING" >&2
  exit 1
fi
S=$1
if [[ $S == *[!()]* ]]; then
  echo "error: '$S' contains characters other than ( and )" >&2
  exit 2
fi
c=0
i=0
bad=
while [ "$i" -lt "${#S}" ]; do
  ch=${S:i:1}
  case $ch in
    '(') c=$((c + 1)) ;;
    ')') c=$((c - 1)) ;;
  esac
  if [ "$c" -lt 0 ]; then
    echo "desbalanceado: cierre extra en posicion $((i + 1))"
    bad=1
    break
  fi
  i=$((i + 1))
done
if [ -z "$bad" ]; then
  if [ "$c" -eq 0 ]; then
    echo balanceado
  else
    echo "desbalanceado: faltan $c cierres"
  fi
fi

