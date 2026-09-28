#!/bin/bash
last | grep -v -e '^$' -e '^wtmp begins' | cut -d' ' -f1 | sort | uniq -c
echo ---
last | grep '([0-9][0-9]:[0-9][0-9])'

