#!/bin/bash
N=$(cat n.txt)
mkdir pages
seq -f '%02g' 1 "$N" | xargs -I{} cp template.txt pages/page_{}.txt
seq -f 'pages/page_%02g.txt' 2 2 "$N" | xargs rm
ls pages | wc -l
ls pages | xargs

