#!/bin/bash
N=$1
for ((i = 1; i <= N; i++)); do echo -n "$i "; done
echo
for i in $(seq "$N" -1 1); do echo "$i"; done
for i in $(seq "$N"); do echo "Iteracion numero $i"; done

