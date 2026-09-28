#!/bin/bash
a=0; s=0; best=-1
while IFS=, read -r n ap nota; do
  echo "${ap^^}, $n: $nota"
  if [ "$nota" -ge 5 ]; then a=$((a + 1)); else s=$((s + 1)); fi
  if [ "$nota" -gt "$best" ]; then best=$nota; bn="$n $ap"; fi
done < <(tail -n +2 alumnos.csv)
echo ---
echo "aprobados: $a, suspensos: $s"
echo "mejor: $bn ($best)"

