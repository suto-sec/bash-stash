#!/bin/bash
exec 3> salida.txt
echo uno >&3
echo dos >&3
exec 3>&-
exec 4< entrada.txt
read -r L1 <&4
read -r L2 <&4
exec 4<&-
echo "$L2"
echo "$L1"

