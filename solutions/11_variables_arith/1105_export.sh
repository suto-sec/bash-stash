#!/bin/bash
LOCAL_VAR=uno
export GLOBAL_VAR=dos
bash -c 'echo "local=[$LOCAL_VAR] global=[$GLOBAL_VAR]"'
printenv GLOBAL_VAR
printenv LOCAL_VAR > /dev/null; echo $?
export LOCAL_VAR
bash -c 'echo "local=[$LOCAL_VAR] global=[$GLOBAL_VAR]"'

