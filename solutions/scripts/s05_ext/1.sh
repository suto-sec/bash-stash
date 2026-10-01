#!/bin/bash
case $1 in
  *.txt) kind=text ;;
  *.sh) kind=script ;;
  *.png|*.jpg) kind=image ;;
  *) kind=other ;;
esac
echo "$1: $kind"
