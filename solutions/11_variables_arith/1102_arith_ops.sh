#!/bin/bash
read A B < nums.txt
echo "$A + $B = $((A + B))"
echo "$A - $B = $((A - B))"
echo "$A * $B = $((A * B))"
echo "$A / $B = $((A / B))"
echo "$A % $B = $((A % B))"
echo "$A ** 2 = $((A ** 2))"

