#!/bin/bash
DIR=${1:-.}
A=$(find "$DIR" -mindepth 1 -maxdepth 1 -type f ! -name '.*' | wc -l)
B=$(find "$DIR" -mindepth 2 -type f ! -name '.*' | wc -l)
echo "Directos: $A"
echo "Anidados: $B"

