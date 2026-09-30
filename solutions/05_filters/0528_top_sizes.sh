#!/bin/bash
sort -t$'\t' -k1,1hr -k2,2 uso.txt | head -n "${1:-5}"

