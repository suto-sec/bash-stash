#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
text=0 code=0 image=0 other=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  case $f in
    *.txt|*.md) text=$((text + 1)) ;;
    *.c|*.sh|*.py) code=$((code + 1)) ;;
    *.png|*.jpg) image=$((image + 1)) ;;
    *) other=$((other + 1)) ;;
  esac
done
total=$((text + code + image + other))
pct() { if (( total )); then echo $((100 * $1 / total)); else echo 0; fi; }
echo "text: $text ($(pct $text)%)"
echo "code: $code ($(pct $code)%)"
echo "image: $image ($(pct $image)%)"
echo "other: $other ($(pct $other)%)"
