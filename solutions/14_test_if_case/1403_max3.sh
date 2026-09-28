#!/bin/bash
M=$1
[ "$2" -gt "$M" ] && M=$2
[ "$3" -gt "$M" ] && M=$3
echo "$M"

