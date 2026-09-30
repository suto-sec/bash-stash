#!/bin/bash
N=$(cat n.txt)
(( N & 1 )) && echo yes || echo no
(( N & 2 )) && echo yes || echo no
(( N & 4 )) && echo yes || echo no
(( N & 8 )) && echo yes || echo no
echo $((N << 1))
echo $((N >> 1))
echo $((N ^ 15))

