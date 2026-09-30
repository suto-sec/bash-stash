#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") N [arg...]" >&2
  exit 1
fi
N=$1
if [[ ! $N =~ ^[0-9]+$ ]]; then
  echo "Invalid count: $N" >&2
  exit 2
fi
shift
# shift N fails (and leaves the arguments untouched) if there are fewer than N
if ! shift "$N"; then
  echo "Cannot skip $N of $# arguments" >&2
  exit 3
fi
for a in "$@"; do
  echo "> $a"
done
echo "($# left)"

