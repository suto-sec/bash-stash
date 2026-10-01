#!/bin/bash
dir=$HOME/reports
if [[ ! -d $dir ]]; then mkdir -p "$dir"; echo "Directory $dir created"; fi
out=$dir/report.txt
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
