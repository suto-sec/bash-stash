#!/bin/bash
F=notas.txt
count() { if [ -f $F ]; then wc -l < $F; else echo 0; fi; }
add()  { echo "$*" >> $F; echo "added ($(count) notes)"; }
list() { if [ -s $F ]; then nl -w1 -s') ' $F; else echo "no notes"; fi; }
del()  {
  if [[ $1 =~ ^[0-9]+$ ]] && [ "$1" -ge 1 ] && [ "$1" -le "$(count)" ]; then
    sed -i "${1}d" $F; echo "deleted $1"
  else echo "no such note"; fi
}
while read -r cmd rest; do
  case $cmd in
    add) add $rest ;;
    list) list ;;
    del) del $rest ;;
    quit) echo bye; break ;;
    *) echo "unknown command: $cmd" >&2 ;;
  esac
done
