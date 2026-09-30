#!/bin/bash
CODE=$(cat codigo.txt)
LEN=$(expr length "$CODE")
NL=$(expr match "$CODE" '[A-Z]*')
echo "$LEN"
echo "$NL"
expr substr "$CODE" 1 "$NL"
expr substr "$CODE" $((NL + 1)) $((LEN - NL))

