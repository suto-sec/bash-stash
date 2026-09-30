#!/bin/bash
needle=$1
shift
p=0
found=
for w in "$@"; do
  p=$((p + 1))
  case $w in
    "$needle") found=$p; break ;;
  esac
done
if [ -n "$found" ]; then
  echo "SI: posicion $found"
else
  echo "NO"
fi

