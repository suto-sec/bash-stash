#!/bin/bash
text=0 script=0 image=0 other=0
for name in "$@"; do
  case $name in
    *.txt) kind=text; text=$((text + 1)) ;;
    *.sh) kind=script; script=$((script + 1)) ;;
    *.png|*.jpg) kind=image; image=$((image + 1)) ;;
    *) kind=other; other=$((other + 1)) ;;
  esac
  echo "$name: $kind"
done
echo "text: $text"
echo "script: $script"
echo "image: $image"
echo "other: $other"
