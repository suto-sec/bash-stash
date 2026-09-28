#!/bin/bash
xargs mkdir -p < dirs.txt
xargs -I{} touch {}/README < dirs.txt
xargs -n2 < numeros.txt

