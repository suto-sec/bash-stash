#!/bin/bash
for f in "$@"; do
  case ${f,,} in
    *.jpg|*.jpeg|*.png|*.gif) t=image ;;
    *.pdf|*.odt|*.docx|*.txt) t=document ;;
    *.tar|*.tgz|*.tar.gz|*.zip) t=archive ;;
    *.sh) t=script ;;
    *) t=unknown ;;
  esac
  echo "$f: $t"
done

