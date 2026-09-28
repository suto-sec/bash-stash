#!/bin/bash
saluda() { echo "Hola, $1!"; }
linea() { echo "===================="; }
for n in "$@"; do
  linea
  saluda "$n"
done
linea

