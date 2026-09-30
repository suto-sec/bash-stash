#!/bin/bash
DIR=${1:-.}
find "$DIR" -type f -printf '%s\n' | sort -n | uniq -c | grep -vE '^ *1 '
N=$(find "$DIR" -type f -printf '%s\n' | sort -n | uniq -c | grep -vE '^ *1 ' | wc -l)
echo "Total: $N grupos"
