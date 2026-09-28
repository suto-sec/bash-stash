#!/bin/bash
tail -n +2 ventas.csv | cut -d, -f2,3 | sort -t, -k2,2nr -k1,1 | head -n 3 | tr , ' '

