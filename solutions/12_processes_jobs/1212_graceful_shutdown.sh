#!/bin/bash
./cleanup.sh a.flag &
P=$!
sleep 0.2
kill "$P"
wait "$P" 2>/dev/null
echo $?
cat a.flag
./cleanup.sh b.flag &
P=$!
sleep 0.2
kill -9 "$P"
wait "$P" 2>/dev/null
echo $?
if [ -e b.flag ]; then echo exists; else echo missing; fi

