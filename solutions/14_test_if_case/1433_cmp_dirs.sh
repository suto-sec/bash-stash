#!/bin/bash
# cmp_dirs.sh dir1 dir2 - compare the regular files of two directories

if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") dir1 dir2" >&2
  exit 2
fi
d1=$1 d2=$2
if [ ! -d "$d1" ]; then
  echo "Error: '$d1' is not a directory" >&2
  exit 3
fi
if [ ! -d "$d2" ]; then
  echo "Error: '$d2' is not a directory" >&2
  exit 4
fi
if [ "$d1" -ef "$d2" ]; then
  echo "Error: both arguments are the same directory" >&2
  exit 5
fi

s=0 d=0 a=0 b=0
for f in "$d1"/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  g=$d2/$name
  if [ ! -e "$g" ]; then echo "only in $d1: $name"; a=$((a + 1))
  elif [ ! -f "$g" ]; then echo "not comparable: $name"; d=$((d + 1))
  elif cmp -s "$f" "$g"; then echo "same: $name"; s=$((s + 1))
  elif [ "$f" -nt "$g" ]; then echo "newer in $d1: $name"; d=$((d + 1))
  elif [ "$g" -nt "$f" ]; then echo "newer in $d2: $name"; d=$((d + 1))
  else echo "differs: $name"; d=$((d + 1))
  fi
done
for g in "$d2"/*; do
  [ -f "$g" ] || continue
  name=$(basename "$g")
  if [ ! -e "$d1/$name" ]; then
    echo "only in $d2: $name"
    b=$((b + 1))
  fi
done
echo "Same: $s, different: $d, only in $d1: $a, only in $d2: $b"
[ $((d + a + b)) -eq 0 ] || exit 1
