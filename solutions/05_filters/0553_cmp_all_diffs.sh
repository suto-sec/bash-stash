#!/bin/bash
D=$(cmp -l orig.bin mod.bin)
echo "$D"
echo "Total: $(echo "$D" | wc -l) bytes differ"

