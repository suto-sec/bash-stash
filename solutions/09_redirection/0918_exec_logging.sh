#!/bin/bash
echo starting
exec 3>&1 4>&2
exec > script.log 2>&1
echo "== files =="
ls datos
ls noexiste
echo "== end =="
exec 1>&3 2>&4 3>&- 4>&-
echo "logged $(wc -l < script.log) lines"

