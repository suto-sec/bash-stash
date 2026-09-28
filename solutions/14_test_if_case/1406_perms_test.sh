#!/bin/bash
for f in "$@"; do
  p=
  [ -r "$f" ] && p+=r || p+=-
  [ -w "$f" ] && p+=w || p+=-
  [ -x "$f" ] && p+=x || p+=-
  echo "$f: $p"
done

