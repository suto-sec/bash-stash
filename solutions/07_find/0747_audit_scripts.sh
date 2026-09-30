#!/bin/bash
DIR=${1:-.}
find "$DIR" -name vendor -prune -o -type f -perm /111 -name '*.sh' -print | sort
N=$(find "$DIR" -name vendor -prune -o -type f -perm /111 -name '*.sh' -print | wc -l)
echo "Total: $N scripts"

