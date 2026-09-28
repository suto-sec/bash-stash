#!/bin/bash
./terco.sh &
P=$!
sleep 0.3
kill "$P"
sleep 0.3
if kill -0 "$P" 2>/dev/null; then echo alive; else echo dead; fi
kill -9 "$P"
wait "$P" 2>/dev/null
S=$?
if kill -0 "$P" 2>/dev/null; then echo alive; else echo dead; fi
echo "$S"

