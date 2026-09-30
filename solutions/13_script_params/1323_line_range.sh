#!/bin/bash
# lines.sh file start [end] - print a range of lines of a file

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $(basename "$0") file start [end]" >&2
  exit 1
fi
file=$1
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "Error: '$file' is not a readable regular file" >&2
  exit 2
fi
for n in "${@:2}"; do
  if [[ ! $n =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: '$n' is not a positive integer" >&2
    exit 3
  fi
done
start=$2
if [ $# -eq 3 ] && [ "$start" -gt "$3" ]; then
  echo "Error: start ($start) is greater than end ($3)" >&2
  exit 4
fi

total=$(wc -l < "$file")
end=${3:-$total}
[ "$end" -gt "$total" ] && end=$total

k=0 num=0
while IFS= read -r line; do
  num=$((num + 1))
  if [ $num -ge "$start" ] && [ $num -le "$end" ]; then
    echo "$num: $line"
    k=$((k + 1))
  fi
done < "$file"
echo "Printed $k of $total lines of $file"

