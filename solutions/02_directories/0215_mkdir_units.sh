#!/bin/bash
C=$(head -n 1 course.txt)
N=$(tail -n 1 course.txt)
mkdir -p "$C/exams/partial" "$C/exams/final" "$C/notes"
for u in $(seq -f 'unit_%02g' "$N"); do
  mkdir "$C/$u"
done
ls "$C"

