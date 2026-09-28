#!/bin/bash
if [[ ! $1 =~ ^[0-9]+$ ]] || [ "$1" -gt 10 ]; then
  echo "Invalid grade" >&2
  exit 1
fi
if [ "$1" -lt 5 ]; then echo Suspenso
elif [ "$1" -lt 7 ]; then echo Aprobado
elif [ "$1" -lt 9 ]; then echo Notable
elif [ "$1" -eq 9 ]; then echo Sobresaliente
else echo "Matricula de Honor"
fi

