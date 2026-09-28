#!/bin/bash
ps -u luke -o pid= | wc -l
echo ---
ps -o user=,comm= -p 1
echo ---
ps -C sleep -o user= | sort -u | grep -v alumno

