#!/bin/bash
sleep 200 &
P=$!
sleep 0.2
ps -o stat= -p "$P"
kill -STOP "$P"
sleep 0.2
ps -o stat= -p "$P"
kill -CONT "$P"
sleep 0.2
ps -o stat= -p "$P"
kill -KILL "$P"
wait "$P" 2>/dev/null
echo $?

