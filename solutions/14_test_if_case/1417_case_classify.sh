#!/bin/bash
for a in "$@"; do
  case $a in
    '') k=empty ;;
    --) k="end of options" ;;
    --*) k="long option" ;;
    -[a-zA-Z]) k="short option" ;;
    *[!0-9]*)
      case $a in
        .*) k=hidden ;;
        */*) k=path ;;
        *.sh) k=script ;;
        *) k=word ;;
      esac
      ;;
    *) k=number ;;
  esac
  echo "'$a': $k"
done

