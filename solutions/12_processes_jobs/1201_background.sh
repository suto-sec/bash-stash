#!/bin/bash
sleep 300 &
P=$!
if kill -0 "$P" 2>/dev/null; then echo running; else echo "not running"; fi
kill "$P"
wait "$P"
echo $?
if kill -0 "$P" 2>/dev/null; then echo running; else echo "not running"; fi

