#!/bin/bash
P=$(cat fichero.txt)
F=${P##*/}
echo "$F"
echo "${P%/*}"
echo "${F%.*}"
echo "${F##*.}"
echo "${P//\//:}"
echo "${P:0:5}"

