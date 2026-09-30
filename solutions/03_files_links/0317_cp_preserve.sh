#!/bin/bash
for f in *.conf; do
  [ -f "$f" ] || continue
  [ -e "$f.bak" ] && mv -f "$f.bak" "$f.bak.old"
  cp -p "$f" "$f.bak"
done

