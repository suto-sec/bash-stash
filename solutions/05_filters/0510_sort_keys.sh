#!/bin/bash
sort -t: -k3,3nr notas.txt
echo ---
sort -t: -k2,2 -k3,3nr notas.txt

