#!/bin/bash
uniq -c -f 1 syslog.txt | sed -E 's/^ *1 //; t; s/^ *([0-9]+) (.*)$/\2 (x\1)/'

