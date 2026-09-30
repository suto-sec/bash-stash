#!/bin/bash
n=0
# IFS= keeps leading/trailing blanks, -r keeps backslashes, || [ -n ] handles the last line
while IFS= read -r l || [ -n "$l" ]; do
  n=$((n + 1))
  printf '%s|%s|%s\n' "$n" "$l" "${#l}"
done < entrada.txt > salida.txt
echo "$n lines processed"

