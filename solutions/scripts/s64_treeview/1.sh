#!/bin/bash
while IFS= read -r p; do
  rel=${p#"$1"/}
  depth=$(tr -cd / <<< "$rel" | wc -c)
  printf '%*s%s\n' $((depth * 2)) '' "${rel##*/}"
done < <(find "$1" -mindepth 1 | sort)
