#!/bin/bash
out=
if [[ $1 == -o ]]; then
  if (( $# != 3 )); then echo "Error: -o needs a file and a directory" >&2; echo "Usage: $0 [-o file] dir" >&2; exit 1; fi
  out=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 [-o file] dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -n $out ]]; then
  [[ -d $(dirname "$out") ]] || { echo "Error: cannot write $out" >&2; exit 5; }
else
  dir=$HOME/reports
  if [[ ! -d $dir ]]; then mkdir -p "$dir"; echo "Directory $dir created"; fi
  out=$dir/report.txt
fi
declare -A n
files=0 bytes=0
while read -r size name; do
  files=$((files + 1)); bytes=$((bytes + size))
  if [[ $name == *.* ]]; then ext=${name##*.}; else ext="(none)"; fi
  n[$ext]=$(( ${n[$ext]:-0} + 1 ))
done < <(find "$1" -type f -printf '%s %f\n')
{
  echo "Files: $files"
  echo "Total bytes: $bytes"
  for e in $(printf '%s\n' "${!n[@]}" | sort); do echo "$e: ${n[$e]}"; done
} > "$out"
echo "Report written to $out"
