#!/bin/bash
n=0; for x in "$*"; do n=$((n + 1)); done; echo $n
n=0; for x in "$@"; do n=$((n + 1)); done; echo $n
n=0; for x in $*; do n=$((n + 1)); done; echo $n
(IFS=,; echo "$*")

