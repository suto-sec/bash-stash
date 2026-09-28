#!/bin/bash
LINE=$(cat frase.txt)
wc -w <<< "$LINE"
tr a-z A-Z <<< "$LINE"
read A B REST <<< "$LINE"
echo "$B $A"

