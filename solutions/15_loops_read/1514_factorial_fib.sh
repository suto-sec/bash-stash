#!/bin/bash
n=$1
f=1
for ((i = 2; i <= n; i++)); do f=$((f * i)); done
echo "$n! = $f"
a=0; b=1
for ((i = 0; i < n; i++)); do t=$((a + b)); a=$b; b=$t; done
echo "fib($n) = $a"

