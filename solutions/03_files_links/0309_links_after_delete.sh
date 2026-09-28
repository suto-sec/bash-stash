#!/bin/bash
ln original duro
ln -s original blando
rm original
cat duro
if [ -e blando ]; then echo ok; else echo broken; fi
stat -c %h duro

