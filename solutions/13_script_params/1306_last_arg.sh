#!/bin/bash
echo "${!#}"
echo "${10:-none}"
if [ $# -ge 3 ]; then echo "${@:2:$#-2}"; else echo; fi

