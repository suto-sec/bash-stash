#!/bin/bash
DIR=${1:-.}
find "$DIR" -type f -newer "$DIR/.marca" -size +1M | sort
N=$(find "$DIR" -type f -newer "$DIR/.marca" -size +1M | wc -l)
echo "Total: $N files"

