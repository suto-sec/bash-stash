#!/bin/bash
ERRORES=0
queja() {
  echo "$*" >&2
  ERRORES=$((ERRORES + 1))
}
V=0
for arg in "$@"; do
  case $arg in
    *=*)
      nombre=${arg%%=*}
      edad=${arg#*=}
      if [[ -z $nombre || $edad == *=* ]]; then
        queja "formato invalido: $arg"; continue
      fi
      ;;
    *)
      queja "formato invalido: $arg"; continue
      ;;
  esac
  if [[ ! $edad =~ ^[0-9]+$ ]]; then
    queja "edad no numerica: $arg"; continue
  fi
  if (( 10#$edad > 120 )); then
    queja "edad fuera de rango: $arg"; continue
  fi
  echo "$nombre: $edad anios"
  V=$((V + 1))
done
echo "validos: $V, avisos: $ERRORES"
[ "$ERRORES" -eq 0 ]

