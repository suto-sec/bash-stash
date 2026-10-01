#!/bin/bash
for name in "$@"; do
  case $name in
    *.txt) kind=text ;;
    *.sh) kind=script ;;
    *.png|*.jpg) kind=image ;;
    *) kind=other ;;
  esac
  echo "$name: $kind"
done
