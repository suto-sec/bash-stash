#!/bin/bash
N=0
for f in reportes/*.rpt; do
  ORIG=$(stat -c%s "$f")
  xz -k "$f"
  COMP=$(stat -c%s "$f.xz")
  echo "$f: $ORIG -> $COMP bytes"
  N=$((N + 1))
done
echo "Total: $N files processed"

