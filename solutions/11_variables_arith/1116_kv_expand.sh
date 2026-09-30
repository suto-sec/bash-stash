#!/bin/bash
LINE=$(cat config.txt)
KEY=${LINE%%=*}
VALUE=${LINE#*=}
echo "$KEY"
echo "$VALUE"
echo "${KEY,,}"
echo "${VALUE//\//_}"
echo "${#VALUE}"

