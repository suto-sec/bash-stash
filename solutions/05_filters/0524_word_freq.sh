#!/bin/bash
tr 'A-Z' 'a-z' < articulo.txt | tr -cs 'a-z' '\n' | grep -v '^$' | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5
