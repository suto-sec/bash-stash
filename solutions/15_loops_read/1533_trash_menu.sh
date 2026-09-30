#!/bin/bash
# papelera.sh DIR
[ $# -eq 1 ] || { echo "usage: $(basename "$0") DIR" >&2; exit 1; }
D=$1
[ -d "$D" ] || { echo "error: '$D' is not a directory" >&2; exit 2; }
T=$D/.trash
del=0; res=0
select op in list delete restore quit; do
  case $op in
    list)
      n=0
      for f in "$D"/*; do
        [ -f "$f" ] && { echo "- ${f##*/}"; n=$((n + 1)); }
      done
      [ $n -eq 0 ] && echo "(no files)"
      if [ -d "$T" ]; then echo "trash: $(ls -A "$T" | wc -l)"; else echo "trash: 0"; fi
      ;;
    delete)
      IFS= read -r name
      if [ -f "$D/$name" ]; then
        mkdir -p "$T"; mv -f "$D/$name" "$T/"; echo "deleted $name"; del=$((del + 1))
      else
        echo "no such file: $name"
      fi
      ;;
    restore)
      IFS= read -r name
      if [ ! -e "$T/$name" ]; then echo "not in trash: $name"
      elif [ -e "$D/$name" ]; then echo "cannot restore $name: exists"
      else mv "$T/$name" "$D/"; echo "restored $name"; res=$((res + 1))
      fi
      ;;
    quit) break ;;
    *) echo "invalid option" ;;
  esac
done
echo "deleted $del, restored $res"

