#!/bin/bash
source ./lib.sh
for a in "$@"; do
  mayus "$a"
  repite 3 "$a"
done

