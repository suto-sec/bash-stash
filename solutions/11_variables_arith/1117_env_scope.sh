#!/bin/bash
MODE=prod
env MODE=test printenv MODE
echo "$MODE"
export MODE
env printenv MODE
unset MODE
env printenv MODE > /dev/null 2>&1
echo $?

