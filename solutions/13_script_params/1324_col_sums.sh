#!/bin/bash
# colsum.sh [-d C] file col... - sum columns of a delimited table with a header

usage() {
  echo "Usage: $(basename "$0") [-d C] file col..." >&2
  exit 1
}

d=,
if [ "$1" = "-d" ]; then
  [ $# -ge 2 ] || usage
  [ ${#2} -eq 1 ] || usage
  d=$2
  shift 2
fi
[ $# -ge 2 ] || usage

file=$1
shift
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "Error: '$file' is not a readable regular file" >&2
  exit 2
fi

# number of columns = number of separators in the header + 1
seps=$(head -n 1 "$file" | tr -cd "$d" | wc -c)
ncols=$((seps + 1))
for c in "$@"; do
  if [[ ! $c =~ ^[1-9][0-9]*$ ]] || [ "$c" -gt "$ncols" ]; then
    echo "Error: invalid column '$c' (the file has $ncols columns)" >&2
    exit 3
  fi
done

for c in "$@"; do
  name=$(head -n 1 "$file" | cut -d "$d" -f "$c")
  sum=0
  for v in $(tail -n +2 "$file" | cut -d "$d" -f "$c"); do
    sum=$((sum + v))
  done
  echo "$name: $sum"
done
echo "Rows: $(tail -n +2 "$file" | wc -l)"

