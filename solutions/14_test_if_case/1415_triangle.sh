#!/bin/bash
usage() {
  echo "Usage: $(basename "$0") a b c" >&2
  exit 1
}
[ $# -eq 3 ] || usage
for s in "$@"; do
  [[ $s =~ ^[0-9]+$ ]] || usage
done
a=$1 b=$2 c=$3
if [ "$a" -eq 0 ] || [ "$b" -eq 0 ] || [ "$c" -eq 0 ] ||
   [ "$a" -ge $((b + c)) ] || [ "$b" -ge $((a + c)) ] || [ "$c" -ge $((a + b)) ]; then
  echo "not a triangle"
  exit 2
fi
if [ "$a" -eq "$b" ] && [ "$b" -eq "$c" ]; then
  t=equilateral
elif [ "$a" -eq "$b" ] || [ "$a" -eq "$c" ] || [ "$b" -eq "$c" ]; then
  t=isosceles
else
  t=scalene
fi
if (( a*a + b*b == c*c || a*a + c*c == b*b || b*b + c*c == a*a )); then
  t="$t right"
fi
echo "$t"

