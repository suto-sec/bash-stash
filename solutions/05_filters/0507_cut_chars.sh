#!/bin/bash
cut -c1-10 ls_output.txt
echo ---
cut -d';' -f1,3 --output-delimiter=' | ' notas.csv

