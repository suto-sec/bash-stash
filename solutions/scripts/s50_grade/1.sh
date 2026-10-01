#!/bin/bash
s=$1
if (( s >= 90 )); then echo A
elif (( s >= 80 )); then echo B
elif (( s >= 70 )); then echo C
elif (( s >= 60 )); then echo D
else echo F
fi
