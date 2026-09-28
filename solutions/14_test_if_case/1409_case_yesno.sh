#!/bin/bash
read -r R
case ${R,,} in
  s|si|sí|y|yes) echo yes ;;
  n|no) echo no ;;
  *) echo "invalid answer: $R"; exit 2 ;;
esac

