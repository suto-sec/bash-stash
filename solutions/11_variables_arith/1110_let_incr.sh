#!/bin/bash
I=5
((I++))
((I += 10))
echo "$I"
S=abc
S+=def
echo "$S"
(( I > 10 )) && echo yes
let "R = I * 2 - 1"
echo "$R"

