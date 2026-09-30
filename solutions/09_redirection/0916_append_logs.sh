#!/bin/bash
BEFORE=0
[ -f err.log ] && BEFORE=$(wc -l < err.log)
while IFS= read -r t; do
  ./job.sh "$t" 2>> err.log | tee -a run.log
done < tareas.txt
echo "errors: $(( $(wc -l < err.log) - BEFORE ))"

