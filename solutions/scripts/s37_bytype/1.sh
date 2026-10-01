#!/bin/bash
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
echo "text: $text"
echo "code: $code"
echo "image: $image"
echo "other: $other"
