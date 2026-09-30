#!/bin/bash
sleep 300 &
P=$!
kill "$P"
wait "$P"
echo $?

