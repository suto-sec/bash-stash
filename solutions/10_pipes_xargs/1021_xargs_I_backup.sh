#!/bin/bash
xargs -I{} cp {} {}.bak < lista.txt
find . -name '*.bak' | sort

