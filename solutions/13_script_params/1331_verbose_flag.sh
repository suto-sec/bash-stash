#!/bin/bash
V=0
M=0
for a in "$@"; do
  case $a in
    -v) V=$((V + 1)) ;;
    *) echo "archivo: $a"; M=$((M + 1)) ;;
  esac
done
echo "verbosidad: $V, archivos: $M"

