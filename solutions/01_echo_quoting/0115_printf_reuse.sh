#!/bin/bash
printf '%-10s %8s\n' NAME SCORE
printf '%-10s %8d\n' $(cat scores.txt)
echo "Players: $(( $(wc -w < scores.txt) / 2 ))"

