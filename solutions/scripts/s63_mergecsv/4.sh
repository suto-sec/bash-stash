#!/bin/bash
uniq=
if [[ $1 == -u ]]; then uniq=1; shift; fi
if (( $# != 2 )); then echo "Error: two files are needed" >&2; echo "Usage: $0 [-u] a.csv b.csv" >&2; exit 1; fi
for f in "$1" "$2"; do
  [[ -f $f && -r $f && -s $f ]] || { echo "Error: cannot use $f" >&2; exit 2; }
done
if [[ $(head -n 1 "$1") != "$(head -n 1 "$2")" ]]; then echo "Error: the headers differ" >&2; exit 4; fi
head -n 1 "$1"
declare -A seen
n=0
while IFS= read -r row; do
  if [[ -n $uniq ]]; then [[ -z ${seen[$row]:-} ]] || continue; seen[$row]=1; fi
  echo "$row"; n=$((n + 1))
done < <(tail -n +2 "$1"; tail -n +2 "$2")
echo "Rows: $n"
