#!/bin/bash
mapfile -t FRUTAS < frutas.txt
echo "${#FRUTAS[@]}"
echo "${FRUTAS[0]} ${FRUTAS[-1]}"
echo "${FRUTAS[@]}"
for i in "${!FRUTAS[@]}"; do echo "$i: ${FRUTAS[i]}"; done

