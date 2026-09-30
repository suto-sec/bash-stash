#!/bin/bash
DIR=${1:-.}
find "$DIR" -type f -size +100k -name '*.*' | sed 's/.*\.//' | sort | uniq -c | sort -k1,1nr -k2,2
N=$(find "$DIR" -type f -size +100k -name '*.*' | wc -l)
echo "Total: $N files"

